import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AssignedPlan } from '../entities/assigned-plan.entity';

import { AssignedPlanService } from './assigned-plan.service';
import { AssignedPlanController } from './assigned-plan.controller';
import { TrainingDay } from '../entities/training-day.entity';

import { User } from '../entities/user.entity';
import { TrainingPlanAi } from '../entities/training-plan-ai.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([AssignedPlan, TrainingDay, User, TrainingPlanAi]),
  ],
  controllers: [AssignedPlanController],
  providers: [AssignedPlanService],
  exports: [AssignedPlanService],
})
export class AssignedPlanModule {}
