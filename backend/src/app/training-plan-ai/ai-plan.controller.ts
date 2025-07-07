import {
  Controller,
  Post,
  Body,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { AiPlanService } from './ai.plan.service';
import { OnboardingAnswersDto } from './dto/onboarding-answers.dto';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { PinoLogger } from 'nestjs-pino';

@ApiTags('AI Training Plans')
@Controller('ai-plan')
export class AiPlanController {
  constructor(
    private readonly service: AiPlanService,
    private readonly logger: PinoLogger,
  ) {
    this.logger.setContext(AiPlanController.name);
  }

  @Post('generate')
  @ApiOperation({ summary: 'Generate a training plan using ChatGPT' })
  async generate(@Body() dto: OnboardingAnswersDto) {
    this.logger.info({ dto }, '🧠 Request to generate AI training plan');

    try {
      const plan = await this.service.generatePlan(dto);
      this.logger.info({ plan }, '✅ Plan generated successfully');
      return { success: true, data: plan };
    } catch (error: any) {
      this.logger.error(
        { error: error.message },
        '❌ Failed to generate AI plan',
      );
      throw new HttpException(
        `Failed to generate training plan: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
