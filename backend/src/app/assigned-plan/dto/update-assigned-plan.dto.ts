import { IsBoolean, IsOptional, IsString, IsNumber } from 'class-validator';

export class UpdateAssignedPlanDto {
  @IsOptional()
  startDate?: string;

  @IsOptional()
  @IsBoolean()
  isCompleted?: boolean;

  @IsOptional()
  @IsString()
  feedback?: string;

  @IsOptional()
  @IsNumber()
  rpe?: number;
}
