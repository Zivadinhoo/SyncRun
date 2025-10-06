import { IsInt, IsOptional, IsString, IsIn } from 'class-validator';

export class UpdateTrainingDayDto {
  @IsOptional()
  @IsIn(['completed', 'upcoming'])
  status?: 'completed' | 'upcoming';

  @IsOptional()
  @IsInt()
  rpe?: number;

  @IsOptional()
  @IsString()
  feedback?: string;
}
