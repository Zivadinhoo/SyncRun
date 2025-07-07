import { IsBoolean, IsNumber, IsOptional, IsString } from 'class-validator';

export class OnboardingAnswersDto {
  @IsString()
  goal: string;

  @IsNumber()
  weeklyRuns: number;

  @IsBoolean()
  notificationsEnabled: boolean;

  @IsString()
  startDate: string;

  @IsString()
  units: string; // km or mi
}
