import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AiPlanController } from './ai-plan.controller';
import { AiPlanService } from './ai.plan.service';
import { LoggerModule } from 'nestjs-pino';

@Module({
  imports: [ConfigModule, LoggerModule.forRoot()],
  controllers: [AiPlanController],
  providers: [AiPlanService],
})
export class AiPlanModule {}
