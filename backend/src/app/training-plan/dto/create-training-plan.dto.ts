import { IsNotEmpty, IsString, IsNumber } from 'class-validator';

export class CreateTrainingPlanDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsString()
  @IsNotEmpty()
  description: string;

  @IsNumber()
  @IsNotEmpty()
  coachId: number;
}
