import { IsOptional, IsInt } from 'class-validator';

export class GetTrainingDayFeedbackDto {
  @IsOptional()
  @IsInt()
  planId?: number;

  @IsOptional()
  @IsInt()
  athleteId?: number;
}
