import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { OnboardingAnswersDto } from './dto/onboarding-answers.dto';
import OpenAI from 'openai';

@Injectable()
export class AiPlanService {
  private readonly openai: OpenAI;

  constructor() {
    this.openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY,
    });
  }

  async generatePlan(dto: OnboardingAnswersDto): Promise<any> {
    const { goal, weeklyRuns, notificationsEnabled, startDate, units } = dto;

    const prompt = `
You are a professional running coach. Based on the following inputs, generate a personalized running plan in JSON format:

- Goal: ${goal}
- Weekly training days: ${weeklyRuns}
- Notifications enabled: ${notificationsEnabled}
- Start date: ${startDate}
- Units: ${units.toUpperCase()}

Include an estimated pace for each non-rest day. The pace should be in the format "min/km" and depend on the type of workout:
- Easy Run: about 60 seconds slower than race pace
- Tempo Run: around race pace
- Interval Training: 20–40 seconds faster than race pace
- Long Run: 45–90 seconds slower than race pace

📝 Output format:
{
  "weeks": [
    {
      "week": 1,
      "days": [
        {
          "day": "Monday",
          "type": "Easy Run",
          "distance": 5,
          "pace": "5:45 min/km"
        },
        {
          "day": "Tuesday",
          "type": "Rest"
        }
      ]
    }
  ]
}

✅ Return ONLY valid JSON. No explanations.
`;

    try {
      const completion = await this.openai.chat.completions.create({
        model: 'gpt-3.5-turbo',
        messages: [
          {
            role: 'system',
            content: 'You are a world-class running coach assistant.',
          },
          {
            role: 'user',
            content: prompt,
          },
        ],
        temperature: 0.7,
      });

      const response = completion.choices[0]?.message?.content;

      if (!response) {
        throw new InternalServerErrorException('No response from OpenAI');
      }

      try {
        return JSON.parse(response);
      } catch {
        throw new InternalServerErrorException(
          'OpenAI response is not valid JSON',
        );
      }
    } catch (error) {
      throw new InternalServerErrorException(
        `Failed to generate plan from OpenAI: ${error.message}`,
      );
    }
  }
}
