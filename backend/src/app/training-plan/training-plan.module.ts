import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TrainingPlan } from '../entities/training-plan.entity';
import { TrainingPlanService } from './training-plan.service';
import { TrainingPlanController } from './training-plan.controller';
import { User } from '../entities/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([TrainingPlan, User])],
  providers: [TrainingPlanService],
  controllers: [TrainingPlanController],
})
export class TrainingPlanModule {}
