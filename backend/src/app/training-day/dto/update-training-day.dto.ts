import { PartialType } from '@nestjs/swagger';
import { CreateTrainingDayDto } from './create-training-day.dto';

export class UpdateTrainingDayDto extends PartialType(CreateTrainingDayDto) {}
