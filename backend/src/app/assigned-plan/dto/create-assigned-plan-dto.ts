import { IsDateString, IsInt } from 'class-validator';

export class CreateAssignedPlanDto {
  @IsInt()
  atheleteId: number;

  @IsInt()
  trainingPlanId: number;

  @IsDateString()
  startDate: string;
}
