import { IsInt, IsString, Min, Max } from 'class-validator';

export class CreateTrainingDayFeedbackDto {
  @IsInt()
  trainingDayId: number;

  @IsString()
  comment: string;

  @IsInt()
  @Min(1)
  @Max(5)
  rating: number;
}
