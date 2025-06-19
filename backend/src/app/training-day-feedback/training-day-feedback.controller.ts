import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Req,
  UseGuards,
  HttpCode,
  NotFoundException,
} from '@nestjs/common';
import { TrainingDayFeedbackService } from './training-day-feedback.service';
import { CreateTrainingDayFeedbackDto } from './dto/create-training-day-feedback.dto';
import { UpdateTrainingDayFeedbackDto } from './dto/update-training-day-feedback.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PinoLogger } from 'nestjs-pino';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { RequestWithUser } from '../common/types/request-with-user';
import { Query } from '@nestjs/common';
import { GetTrainingDayFeedbackDto } from './dto/get-training-day-feedback.query.dto';

@ApiTags('TrainingDayFeedback')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('training-day-feedback')
export class TrainingDayFeedbackController {
  constructor(
    private readonly feedbackService: TrainingDayFeedbackService,
    private readonly logger: PinoLogger,
  ) {
    this.logger.setContext(TrainingDayFeedbackController.name);
  }

  @Post()
  @ApiOperation({
    summary: 'Create feedback for a specific training day (Athlete only)',
  })
  @ApiResponse({ status: 201, description: 'Feedback created successfully' })
  async create(
    @Req() req: RequestWithUser,
    @Body() dto: CreateTrainingDayFeedbackDto,
  ) {
    try {
      return await this.feedbackService.create(req.user.id, dto);
    } catch (error) {
      this.logger.error('Error creating feedback', error);
      throw error;
    }
  }

  @Get('for-coach')
  @ApiOperation({ summary: 'Get feedbacks for coach(filtered)' })
  @ApiResponse({ status: 200, description: 'Returns feedback for coach' })
  async getForCoach(@Query() query: GetTrainingDayFeedbackDto) {
    try {
      return await this.feedbackService.findForCoach(query);
    } catch (error) {
      this.logger.error('Error fetching coach feedbacks', error);
      throw error;
    }
  }

  @Get('by-training-day/:trainingDayId')
  @ApiOperation({
    summary: 'Get feedback for a specific training day(athlete only)',
  })
  @ApiResponse({
    status: 200,
    description: 'Returns feedback for this training day and athlete',
  })
  @Get('by-training-day/:trainingDayId')
  async getByTrainingDay(
    @Param('trainingDayId') trainingDayId: string,
    @Req() req: RequestWithUser,
  ) {
    try {
      const feedback = await this.feedbackService.findOneByTrainingDay(
        +trainingDayId,
        req.user.id,
      );

      if (!feedback) {
        throw new NotFoundException(
          `No feedback for training day ${trainingDayId} and user ${req.user.id}`,
        );
      }

      return feedback;
    } catch (error) {
      this.logger.error(
        `Error fetching feedback for trainingDay ${trainingDayId}`,
        error,
      );
      throw error;
    }
  }

  @Get('by-athlete/:athleteId')
  @ApiOperation({
    summary: 'Get all feedbacks left by specific athlete (for coach)',
  })
  @ApiResponse({
    status: 200,
    description: 'Returns all feedbacks left by the given athlete',
  })
  async getByAthlete(@Param('athleteId') athleteId: string) {
    try {
      return await this.feedbackService.findForCoach({ athleteId: +athleteId });
    } catch (error) {
      this.logger.error(
        `Error fetching feedbacks by athlete ${athleteId}`,
        error,
      );
      throw error;
    }
  }

  @Get()
  @ApiOperation({ summary: 'Get all training day feedbacks' })
  @ApiResponse({
    status: 200,
    description: 'Returns all feedbacks with user and training day info',
  })
  async findAll() {
    try {
      return await this.feedbackService.findAll();
    } catch (error) {
      this.logger.error('Error fetching all feedback', error);
      throw error;
    }
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get feedback by ID' })
  @ApiResponse({
    status: 200,
    description: 'Returns feedback with user and training day info',
  })
  async findOne(@Param('id') id: string) {
    try {
      return await this.feedbackService.findOne(+id);
    } catch (error) {
      this.logger.error(`Error fetching feedback with ID ${id}`, error);
      throw error;
    }
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update your own feedback (Athlete only)' })
  @ApiResponse({ status: 200, description: 'Feedback updated successfully' })
  async update(
    @Param('id') id: string,
    @Req() req: RequestWithUser,
    @Body() dto: UpdateTrainingDayFeedbackDto,
  ) {
    try {
      return await this.feedbackService.update(+id, req.user.id, dto);
    } catch (error) {
      this.logger.error(`Error updating feedback with ID ${id}`, error);
      throw error;
    }
  }

  @Delete(':id')
  @HttpCode(204)
  @ApiOperation({ summary: 'Soft delete your own feedback' })
  @ApiResponse({
    status: 204,
    description: 'Feedback soft deleted successfully',
  })
  async remove(@Param('id') id: string, @Req() req: RequestWithUser) {
    try {
      await this.feedbackService.remove(+id, req.user.id);
    } catch (error) {
      this.logger.error(`Error deleting feedback with ID ${id}`, error);
      throw error;
    }
  }

  @Patch(':id/restore')
  @ApiOperation({ summary: 'Restore your previously deleted feedback' })
  @ApiResponse({ status: 200, description: 'Feedback restored successfully' })
  async restore(@Param('id') id: string, @Req() req: RequestWithUser) {
    try {
      await this.feedbackService.restore(+id, req.user.id);
    } catch (error) {
      this.logger.error(`Error restoring feedback with ID ${id}`, error);
      throw error;
    }
  }
}
