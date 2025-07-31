import {
  Injectable,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import OpenAI from 'openai';

import { OnboardingAnswersDto } from './dto/onboarding-answers.dto';
import { TrainingPlanAi } from '../entities/training-plan-ai.entity';
import { User } from '../entities/user.entity';
import { buildPromptWithRecoveryFromDto } from './utils/prompt-builder';
import { isValidAiPlan } from './utils/ai-plan.validator';
import { resolvePlanName } from './utils/resolve-plan-name';

@Injectable()
export class AiPlanService {
  private readonly openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
  private readonly logger = new Logger(AiPlanService.name);

  constructor(
    @InjectRepository(TrainingPlanAi)
    private readonly aiPlanRepository: Repository<TrainingPlanAi>,
  ) {}

  async getPlanForUser(userId: number): Promise<TrainingPlanAi | null> {
    try {
      return await this.aiPlanRepository.findOne({
        where: { userId },
        relations: ['user'],
        order: { createdAt: 'DESC' },
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
    const prompt = buildPromptWithRecoveryFromDto(dto);
    const resolvedGoalText = dto.goalText ?? 'Training';
    let rawResponse = '';
    let parsedResponse: any;

    try {
      const completion = await this.openai.chat.completions.create({
        model: 'gpt-3.5-turbo',
        temperature: 0.7,

        messages: [
          {
            role: 'system',
            content: `
You are a world-class endurance running coach AI.

Your job is to generate structured, safe, and realistic training plans for runners training for races like 5K, 10K, half marathons, and marathons.

You always:
- Follow modern training principles: periodization, progressive overload, tapering, and recovery
- Ensure a gradual build-up in weekly volume and long runs
- Include a taper in the last 1–3 weeks depending on the race
- Avoid placing hard sessions back-to-back
- Always include at least one full rest day per week
- Limit volume spikes (no more than 10% increase week-to-week)
- Only train on the user’s preferred days and respect their max days/week
- End the plan with a Race Day

You return **only strict JSON**. Never return markdown, explanations, or code blocks.

If the plan cannot be generated for any reason, return a JSON object with an "error" key and message.
`,
          },

          {
            role: 'user',
            content: prompt,
          },
        ],
      });

      rawResponse = completion.choices[0]?.message?.content?.trim() ?? '';

      if (!rawResponse) {
        throw new InternalServerErrorException('No response from OpenAI');
      }

      if (rawResponse.startsWith('```json')) {
        rawResponse = rawResponse.replace(/```json|```/g, '').trim();
      }

      this.logger.debug({ rawResponse }, '🧠 Raw OpenAI response');

      try {
        parsedResponse = JSON.parse(rawResponse);

        // Normalize format if metadata wrapper is present
        if (parsedResponse?.metadata?.weeks) {
          parsedResponse.weeks = parsedResponse.metadata.weeks;
          parsedResponse.generatedByModel ??=
            parsedResponse.metadata.generatedByModel;
          delete parsedResponse.metadata;
        }
      } catch (parseError) {
        this.logger.error(
          { error: parseError, rawResponse },
          '❌ Failed to parse OpenAI JSON',
        );
        throw new InternalServerErrorException(
          'OpenAI response is not valid JSON',
        );
      }

      // ✅ Validate structure and content
      const isValid = isValidAiPlan(
        parsedResponse,
        dto.daysPerWeek,
        dto.durationInWeeks,
      );

      if (!isValid) {
        this.logger.warn(
          { parsedResponse, userId },
          '❌ Parsed plan failed validation rules',
        );
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

      const duration =
        parsedResponse?.durationInWeeks ?? dto.durationInWeeks ?? 8;

      const plan = this.aiPlanRepository.create({
        name:
          parsedResponse?.name ??
          resolvePlanName(dto.targetDistance, dto.experience),
        description:
          parsedResponse?.description ??
          `${duration}-week plan for ${resolvedGoalText}`,
        durationInWeeks: duration,
        goalRaceDistance:
          parsedResponse?.goalRaceDistance ?? dto.targetDistance,
        goalTag: dto.goalTag,
        goalText: resolvedGoalText,
        generatedByModel: parsedResponse?.generatedByModel ?? 'gpt4o',
        metadata: parsedResponse,
        user,
      });

      return await this.aiPlanRepository.save(plan);
    } catch (error) {
      this.logger.error(
        { error: error.stack ?? error.message },
        '❌ Plan generation failed',
      );
      throw new InternalServerErrorException(
        `Failed to generate plan from OpenAI: ${error.message}`,
      );
    }
  }
}
