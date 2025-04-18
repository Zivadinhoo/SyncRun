import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TrainingDay } from '../entities/training-day.entity';
import { TrainingPlan } from '../entities/training-plan.entity';
import { TrainingDayService } from './training-day.service';
import { TrainingDayController } from './training-day.controller';

@Module({
  imports: [TypeOrmModule.forFeature([TrainingDay, TrainingPlan])],
  controllers: [TrainingDayController],
  providers: [TrainingDayService],
})
export class TrainingDayModule {}
