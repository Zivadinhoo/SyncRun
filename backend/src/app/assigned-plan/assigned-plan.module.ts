import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AssignedPlan } from '../entities/assigned-plan.entity';
import { TrainingPlan } from '../entities/training-plan.entity';
import { AssignedPlanService } from './assigned-plan.service';
import { AssignedPlanController } from './assigned-plan.controller';

@Module({
  imports: [TypeOrmModule.forFeature([AssignedPlan, TrainingPlan])],
  controllers: [AssignedPlanController],
  providers: [AssignedPlanService],
  exports: [AssignedPlanService],
})
export class AssignedPlanModule {}
