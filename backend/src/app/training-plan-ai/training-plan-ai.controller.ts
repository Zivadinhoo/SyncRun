import {
  Controller,
  Post,
  Body,
  HttpException,
  HttpStatus,
  UseGuards,
  Req,
  Get,
} from '@nestjs/common';
import { AiPlanService } from './training-plan-ai.service';
import { OnboardingAnswersDto } from './dto/onboarding-answers.dto';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiBody } from '@nestjs/swagger';
import { PinoLogger } from 'nestjs-pino';
import { RequestWithUser } from '../common/types/request-with-user';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

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
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Generate a training plan using OpenAI (ChatGPT)' })
  @ApiBody({ type: OnboardingAnswersDto })
  async generate(
    @Body() dto: OnboardingAnswersDto,
    @Req() req: RequestWithUser,
  ) {
    const userId = req.user.id;

    this.logger.info(
      { userId, dto },
      '🧠 Received request to generate AI training plan',
    );

    try {
      const plan = await this.service.generatePlan(dto, userId);
      this.logger.info({ userId, planId: plan.id }, '✅ Plan generated');
      return {
        success: true,
        message: 'Plan generated successfully',
        data: plan,
      };
    } catch (error: any) {
      this.logger.error(
        { userId, error: error.message },
        '❌ Plan generation failed',
      );
      throw new HttpException(
        `Failed to generate training plan: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get AI training plan for the logged-in user' })
  async getMyPlan(@Req() req: RequestWithUser) {
    const userId = req.user.id;

    try {
      const plan = await this.service.getPlanForUser(userId);

      return {
        success: true,
        message: plan
          ? 'Plan retrieved successfully'
          : 'No plan found for this user',
        data: plan,
      };
    } catch (error: any) {
      this.logger.error(
        { userId, error: error.message },
        '❌ Failed to fetch plan',
      );
      throw new HttpException(
        `Failed to get training plan: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
