import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TrainingDay } from '../entities/training-day.entity';
import { TrainingDayService } from './training-day.service';
import { TrainingDayController } from './training-day.controller';
import { TrainingDayFeedback } from '../entities/training-day-feedback.entity';
import { AssignedPlan } from '../entities/assigned-plan.entity';
import { TrainingPlanAi } from '../entities/training-plan-ai.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      TrainingDay,
      AssignedPlan,
      TrainingDayFeedback,
      TrainingPlanAi,
    ]),
  ],
  controllers: [TrainingDayController],
  providers: [TrainingDayService],
  exports: [TrainingDayService],
})
export class TrainingDayModule {}
