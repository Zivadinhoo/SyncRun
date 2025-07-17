import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { OnboardingAnswersDto } from './dto/onboarding-answers.dto';
import OpenAI from 'openai';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TrainingPlanAi } from '../entities/training-plan-ai.entity';
import { buildPromptFromDto } from './utils/prompt-builder';
import { GoalType } from '../common/enums/goal-type.enum';
import { User } from '../entities/user.entity';

@Injectable()
export class AiPlanService {
  private readonly openai: OpenAI;

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
        model: 'gpt-3.5-turbo',
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
      } catch {
        throw new InternalServerErrorException(
          'OpenAI response is not valid JSON',
        );
      }

      // ✅ Fetch the full user entity
      const user = await this.aiPlanRepository.manager.findOne(User, {
        where: { id: userId },
      });

      if (!user) {
        throw new InternalServerErrorException('User not found');
      }

      const plan = this.aiPlanRepository.create({
        name: `AI Plan (${dto.goalText})`,
        description: `Plan generated for ${dto.goalText}`,
        durationInWeeks: parsed?.durationInWeeks ?? null,
        goalRaceDistance: dto.targetDistance ?? null,
        goalTag: dto.goalTag,
        goalText: dto.goalText ?? '',
        generatedByModel: 'gpt-3.5-turbo',
        metadata: parsed,
        user, // ✅ This sets userId too
      });

      return await this.aiPlanRepository.save(plan);
    } catch (error) {
      throw new InternalServerErrorException(
        `Failed to generate plan from OpenAI: ${error.message}`,
      );
    }
  }
}
