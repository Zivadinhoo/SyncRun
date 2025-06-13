import { IsDateString, IsOptional, IsInt } from 'class-validator';

export class GetWeeklySummaryDto {
  @IsDateString()
  startDate: string;

  @IsDateString()
  endDate: string;

  @IsOptional()
  @IsInt()
  athleteId?: number;
}
