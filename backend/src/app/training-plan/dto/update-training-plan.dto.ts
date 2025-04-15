import { PartialType } from '@nestjs/mapped-types';
import { CreateTrainingPlanDto } from './create-training-plan.dto';
import { IsEnum, IsInt, IsOptional, IsString } from 'class-validator';
import { TrainingLevel } from 'src/app/entities/training-plan.entity';

export class UpdateTrainingPlanDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsEnum(TrainingLevel)
  level?: TrainingLevel;

  @IsOptional()
  @IsInt()
  durationInWeeks?: number;
}
