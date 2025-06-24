import { IsInt } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SetActiveAssignedPlanDto {
  @ApiProperty({ example: 42 })
  @IsInt()
  assignedPlanId: number;
}
