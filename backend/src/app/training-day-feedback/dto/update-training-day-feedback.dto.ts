import { IsOptional, IsInt, IsString, Min, Max } from 'class-validator';

export class UpdateTrainingDayFeedbackDto {
  @IsOptional()
  @IsString()
  comment?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(5)
  rating?: number;
}
