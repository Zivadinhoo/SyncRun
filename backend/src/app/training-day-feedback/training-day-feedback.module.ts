import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TrainingDayFeedback } from '../entities/training-day-feedback.entity';
import { TrainingDayFeedbackService } from './training-day-feedback.service';
import { TrainingDayFeedbackController } from './training-day-feedback.controller';
import { TrainingDay } from '../entities/training-day.entity';
import { PinoLogger } from 'nestjs-pino';

@Module({
  imports: [TypeOrmModule.forFeature([TrainingDayFeedback, TrainingDay])],
  controllers: [TrainingDayFeedbackController],
  providers: [TrainingDayFeedbackService, PinoLogger],
})
export class TrainingDayFeedbackModule {}
