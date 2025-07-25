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
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiBody,
  ApiResponse,
} from '@nestjs/swagger';
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
  @ApiResponse({
    status: 201,
    description: 'AI-generated training plan returned successfully',
  })
  @ApiResponse({
    status: 500,
    description: 'Failed to generate training plan',
  })
  async generatePlan(
    @Body() dto: OnboardingAnswersDto,
    @Req() req: RequestWithUser,
  ): Promise<any> {
    const userId = req.user.id;

    this.logger.info('🧠 Received AI plan generation request', { userId, dto });

    try {
      const plan = await this.service.generatePlan(dto, userId);
      this.logger.info('✅ AI plan generated', { userId, planId: plan.id });

      return {
        success: true,
        message: 'Plan generated successfully',
        data: plan,
      };
    } catch (error: any) {
      this.logger.error('❌ Failed to generate plan', {
        userId,
        error: error.message,
      });

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
  @ApiResponse({
    status: 200,
    description: 'Fetched AI plan for the current user',
  })
  @ApiResponse({
    status: 500,
    description: 'Internal server error',
  })
  async getMyPlan(@Req() req: RequestWithUser): Promise<any> {
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
      this.logger.error('❌ Failed to fetch user plan', {
        userId,
        error: error.message,
      });

      throw new HttpException(
        `Failed to get training plan: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
