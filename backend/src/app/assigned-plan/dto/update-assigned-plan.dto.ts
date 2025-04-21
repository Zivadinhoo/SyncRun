import { IsBoolean, IsOptional, IsDateString } from 'class-validator';

export class UpdateAssignedPlanDto {
  @IsOptional()
  @IsBoolean()
  IsCompleted?: boolean;

  @IsOptional()
  @IsDateString()
  startDate?: string;
}
