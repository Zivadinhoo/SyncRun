import { CreateTrainingDayDto } from './create-training-day.dto';
import { IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateTrainingDayBulkDto {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateTrainingDayDto)
  items: CreateTrainingDayDto[];
}
