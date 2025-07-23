import {
  Injectable,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';
import { OnboardingAnswersDto } from './dto/onboarding-answers.dto';
import OpenAI from 'openai';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TrainingPlanAi } from '../entities/training-plan-ai.entity';
import { buildPromptFromDto } from './utils/prompt-builder';
import { User } from '../entities/user.entity';
import { isValidAiPlan } from './utils/ai-plan.validator';

@Injectable()
export class AiPlanService {
  private readonly openai: OpenAI;
  private readonly logger = new Logger(AiPlanService.name);

  constructor(
    @InjectRepository(TrainingPlanAi)
    private readonly aiPlanRepository: Repository<TrainingPlanAi>,
  ) {
    this.openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY,
    });
  }

  async getPlanForUser(userId: number) {
    try {
      return await this.aiPlanRepository.findOne({
        where: { userId },
        relations: ['user'],
      });
    } catch (error) {
      this.logger.error('Failed to fetch AI plan', error.stack);
      throw new InternalServerErrorException(
        `Failed to fetch AI plan: ${error.message}`,
      );
    }
  }

  async generatePlan(
    dto: OnboardingAnswersDto,
    userId: number,
  ): Promise<TrainingPlanAi> {
    const prompt = buildPromptFromDto(dto);

    try {
      const completion = await this.openai.chat.completions.create({
        model: 'gpt-4o', // 💡 koristi moćniji model
        messages: [
          {
            role: 'system',
            content: 'You are a world-class running coach assistant.',
          },
          { role: 'user', content: prompt },
        ],
        temperature: 0.7,
      });

      const response = completion.choices[0]?.message?.content;

      if (!response) {
        throw new InternalServerErrorException('No response from OpenAI');
      }

      let parsed;
      try {
        parsed = JSON.parse(response);
      } catch (err) {
        this.logger.error('Failed to parse OpenAI response', err);
        throw new InternalServerErrorException(
          'OpenAI response is not valid JSON',
        );
      }

      // ✅ Validate OpenAI response structure
      if (!isValidAiPlan(parsed, dto.daysPerWeek)) {
        this.logger.warn('Parsed plan failed validation');
        throw new InternalServerErrorException(
          'Generated plan is invalid or inconsistent',
        );
      }

      // ✅ Fetch user
      const user = await this.aiPlanRepository.manager.findOne(User, {
        where: { id: userId },
      });

      if (!user) {
        throw new InternalServerErrorException('User not found');
      }

      const duration = parsed?.durationInWeeks ?? dto.durationInWeeks ?? 8;

      const plan = this.aiPlanRepository.create({
        name: parsed?.name ?? `AI Plan (${dto.goalText})`,
        description:
          parsed?.description ?? `${duration}-week plan for ${dto.goalText}`,
        durationInWeeks: duration,
        goalRaceDistance: parsed?.goalRaceDistance ?? dto.targetDistance,
        goalTag: dto.goalTag,
        goalText: dto.goalText,
        generatedByModel: 'gpt-4o',
        metadata: parsed,
        user,
      });

      return await this.aiPlanRepository.save(plan);
    } catch (error) {
      this.logger.error('Plan generation failed', error.stack);
      throw new InternalServerErrorException(
        `Failed to generate plan from OpenAI: ${error.message}`,
      );
    }
  }
}
