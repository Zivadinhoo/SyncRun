import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AssignedPlan } from '../entities/assigned-plan.entity';
import { TrainingPlan } from '../entities/training-plan.entity';
import { AssignedPlanService } from './assigned-plan.service';
import { AssignedPlanController } from './assigned-plan.controller';
import { TrainingDay } from '../entities/training-day.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([AssignedPlan, TrainingPlan, TrainingDay]),
  ],
  controllers: [AssignedPlanController],
  providers: [AssignedPlanService],
  exports: [AssignedPlanService],
})
export class AssignedPlanModule {}
