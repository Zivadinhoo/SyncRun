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
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
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
  @ApiOperation({ summary: 'Generate a training plan using ChatGPT' })
  async generate(
    @Body() dto: OnboardingAnswersDto,
    @Req() req: RequestWithUser,
  ) {
    const userId = req.user.id;
    this.logger.info(
      { userId, dto },
      '🧠 Request to generate AI training plan',
    );

    try {
      const plan = await this.service.generatePlan(dto, userId);
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

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get my AI training plan' })
  async getMyPlan(@Req() req: RequestWithUser) {
    const userId = req.user.id;

    try {
      const plan = await this.service.getPlanForUser(userId);
      return { success: true, data: plan };
    } catch (error: any) {
      this.logger.error(
        { error: error.message },
        '❌ Failed to retrieve AI plan',
      );
      throw new HttpException(
        `Failed to get training plan: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
