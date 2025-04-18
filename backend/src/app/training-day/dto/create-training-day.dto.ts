import { IsInt, IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class CreateTrainingDayDto {
  @IsInt()
  dayNumber: number;

  @IsString()
  @IsNotEmpty()
  title: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsInt()
  trainingPlanId: number;
}
