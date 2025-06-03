import { IsDateString, IsInt } from 'class-validator';

export class CreateAssignedPlanDto {
  @IsInt()
  athleteId: number;

  @IsInt()
  trainingPlanId: number;

  @IsDateString()
  startDate: string;
}
