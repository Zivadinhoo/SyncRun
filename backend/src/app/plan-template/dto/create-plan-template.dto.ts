// src/app/plan-template/dto/create-plan-template.dto.ts
import {
  IsString,
  IsInt,
  IsArray,
  ValidateNested,
  IsOptional,
  Min,
  Max,
} from 'class-validator';
import { Type } from 'class-transformer';

class PlanTemplateDayDto {
  @IsString()
  day: string; // "Monday", "Tuesday", ...

  @IsString()
  sessionType: string; // "Easy", "Tempo", "Long Run", ...

  @IsString()
  description: string;

  @IsOptional()
  @IsInt()
  tss?: number;
}

class PlanTemplateWeekDto {
  @IsInt()
  weekNumber: number;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => PlanTemplateDayDto)
  days: PlanTemplateDayDto[];
}

export class CreatePlanTemplateDto {
  @IsString()
  name: string;

  @IsString()
  targetRace: string; // "21K", "42K", "Trail", ...

  @IsInt()
  @Min(1)
  @Max(52)
  durationInWeeks: number;

  @IsInt()
  @Min(1)
  @Max(7)
  daysPerWeek: number;

  @IsString()
  description: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => PlanTemplateWeekDto)
  weeks: PlanTemplateWeekDto[];
}
