// src/app/plan-template/dto/update-plan-template.dto.ts
import { PartialType } from '@nestjs/mapped-types';
import { CreatePlanTemplateDto } from './create-plan-template.dto';

export class UpdatePlanTemplateDto extends PartialType(CreatePlanTemplateDto) {}
