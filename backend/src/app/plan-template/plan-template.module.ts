import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PlanTemplate } from '../entities/plan-template.entity';
import { PlanTemplateWeek } from '../entities/plan-template-week.entity';
import { PlanTemplateService } from './plan-template.service';
import { PlanTemplateController } from './plan-template.controller';
import { LoggerModule } from 'nestjs-pino';

@Module({
  imports: [
    TypeOrmModule.forFeature([PlanTemplate, PlanTemplateWeek]),
    LoggerModule,
  ],
  controllers: [PlanTemplateController],
  providers: [PlanTemplateService],
  exports: [PlanTemplateService],
})
export class PlanTemplateModule {}
