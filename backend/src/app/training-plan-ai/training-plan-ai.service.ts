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
      this.logger.error('❌ Failed to fetch AI plan', error.stack);
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
    const resolvedGoalText = dto.goalText ?? 'Training';

    try {
      const completion = await this.openai.chat.completions.create({
        model: 'gpt-4o',
        messages: [
          {
            role: 'system',
            content: 'You are a world-class running coach assistant.',
          },
          { role: 'user', content: prompt },
        ],
        temperature: 0.7,
      });

      const rawResponse = completion.choices[0]?.message?.content;

      if (!rawResponse) {
        throw new InternalServerErrorException('No response from OpenAI');
      }

      // 🧼 Clean and sanitize response
      let cleaned = rawResponse.trim();
      if (cleaned.startsWith('```json')) {
        cleaned = cleaned.replace(/```json|```/g, '').trim();
      }

      this.logger.debug({ rawResponse: cleaned }, '🧠 Raw OpenAI response');

      let parsed: any;
      try {
        parsed = JSON.parse(cleaned);

        // 🔁 Normalize nested structure
        if (parsed?.metadata?.weeks) {
          parsed.weeks = parsed.metadata.weeks;
          if (parsed.metadata.generatedByModel) {
            parsed.generatedByModel = parsed.metadata.generatedByModel;
          }
          delete parsed.metadata;
        }
      } catch (err) {
        this.logger.error(
          { error: err, rawResponse },
          '❌ Failed to parse OpenAI response',
        );
        throw new InternalServerErrorException(
          'OpenAI response is not valid JSON',
        );
      }

      // ✅ Validate plan structure with new rules
      if (!isValidAiPlan(parsed, dto.daysPerWeek, dto.durationInWeeks)) {
        this.logger.warn('❌ Parsed plan failed validation');
        throw new InternalServerErrorException(
          'Generated plan is invalid or inconsistent',
        );
      }

      const user = await this.aiPlanRepository.manager.findOne(User, {
        where: { id: userId },
      });

      if (!user) {
        throw new InternalServerErrorException('User not found');
      }

      const duration = parsed?.durationInWeeks ?? dto.durationInWeeks ?? 8;

      const plan = this.aiPlanRepository.create({
        name: parsed?.name ?? `AI Plan (${resolvedGoalText})`,
        description:
          parsed?.description ??
          `${duration}-week plan for ${resolvedGoalText}`,
        durationInWeeks: duration,
        goalRaceDistance: parsed?.goalRaceDistance ?? dto.targetDistance,
        goalTag: dto.goalTag,
        goalText: resolvedGoalText,
        generatedByModel: parsed?.generatedByModel ?? 'gpt-4o',
        metadata: parsed,
        user,
      });

      return await this.aiPlanRepository.save(plan);
    } catch (error) {
      this.logger.error('❌ Plan generation failed', error.stack);
      throw new InternalServerErrorException(
        `Failed to generate plan from OpenAI: ${error.message}`,
      );
    }
  }
}
