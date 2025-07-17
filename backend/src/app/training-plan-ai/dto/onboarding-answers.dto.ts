import {
  IsBoolean,
  IsNumber,
  IsOptional,
  IsString,
  IsArray,
  ArrayNotEmpty,
  IsDateString,
  IsIn,
  Min,
  Max,
  IsISO8601,
  IsEnum,
} from 'class-validator';
import { GoalType } from 'src/app/common/enums/goal-type.enum';

export class OnboardingAnswersDto {
  @IsEnum(GoalType)
  goalTag: GoalType;

  @IsString()
  goalText: string; // npr: "I’m training for a race"

  @IsString()
  targetDistance: string; // npr: "Half Marathon"

  @IsString()
  targetTime: string; // npr: "1h 50m"

  @IsIn(['Beginner', 'Intermediate', 'Advanced'])
  experience: string;

  @IsNumber()
  @Min(1)
  @Max(7)
  daysPerWeek: number;

  @IsArray()
  @ArrayNotEmpty()
  @IsIn(
    [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ],
    { each: true },
  )
  preferredDays: string[];

  @IsISO8601()
  startDate: string;

  @IsBoolean()
  wantsNotifications: boolean;

  @IsIn(['km', 'mi'])
  units: string;
}
