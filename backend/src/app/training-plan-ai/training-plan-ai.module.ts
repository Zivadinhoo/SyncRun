import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AiPlanController } from './training-plan-ai.controller';
import { AiPlanService } from './training-plan-ai.service';
import { LoggerModule } from 'nestjs-pino';

@Module({
  imports: [ConfigModule, LoggerModule.forRoot()],
  controllers: [AiPlanController],
  providers: [AiPlanService],
})
export class AiPlanModule {}
