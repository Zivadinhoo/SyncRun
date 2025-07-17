import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AiPlanController } from './training-plan-ai.controller';
import { AiPlanService } from './training-plan-ai.service';
import { TrainingPlanAi } from '../entities/training-plan-ai.entity';

@Module({
  imports: [TypeOrmModule.forFeature([TrainingPlanAi])],
  controllers: [AiPlanController],
  providers: [AiPlanService],
  exports: [AiPlanService],
})
export class AiPlanModule {}
