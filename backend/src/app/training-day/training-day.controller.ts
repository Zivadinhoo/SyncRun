import {
  Controller,
  Get,
  Post,
  Patch,
  Param,
  Body,
  ParseIntPipe,
  Query,
} from '@nestjs/common';
import { TrainingDayService } from './training-day.service';

import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiParam,
  ApiQuery,
} from '@nestjs/swagger';
import { Logger } from 'nestjs-pino';
import { UpdateTrainingDayDto } from './dto/update-training-day.dto';

@ApiTags('Training Days')
@ApiBearerAuth('access-token')
@Controller('training-days')
export class TrainingDayController {
  constructor(
    private readonly trainingDayService: TrainingDayService,
    private readonly logger: Logger,
  ) {}

  @Post('generate')
  @ApiOperation({
    summary: 'Generate training days from AI plan into assigned plan',
    description:
      'Takes a generated AI plan and maps it to an assigned plan by creating associated training days.',
  })
  @ApiQuery({ name: 'trainingPlanId', required: true, type: Number })
  @ApiQuery({ name: 'assignedPlanId', required: true, type: Number })
  async generateFromAiPlan(
    @Query('trainingPlanId', ParseIntPipe) trainingPlanId: number,
    @Query('assignedPlanId', ParseIntPipe) assignedPlanId: number,
  ) {
    this.logger.log(
      `Generating training days from AI plan ${trainingPlanId} → assigned plan ${assignedPlanId}`,
    );
    return this.trainingDayService.generateFromAiPlan(
      trainingPlanId,
      assignedPlanId,
    );
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get training day by ID' })
  @ApiParam({ name: 'id', type: Number })
  async findOne(@Param('id', ParseIntPipe) id: number) {
    this.logger.log(`Fetching training day ${id}`);
    return this.trainingDayService.findOne(id);
  }

  @Get('/by-assigned-plan/:assignedPlanId')
  @ApiOperation({ summary: 'Get all training days for an assigned plan' })
  @ApiParam({ name: 'assignedPlanId', type: Number })
  async findByAssignedPlan(
    @Param('assignedPlanId', ParseIntPipe) assignedPlanId: number,
  ) {
    this.logger.log(
      `Fetching training days for assigned plan ${assignedPlanId}`,
    );
    return this.trainingDayService.findByAssignedPlanId(assignedPlanId);
  }

  @Patch(':id')
  @ApiOperation({
    summary: 'Update a training day (status, RPE, feedback)',
    description:
      'Allows the athlete to update the status (e.g. completed), RPE, and feedback for a specific training day.',
  })
  @ApiParam({ name: 'id', type: Number })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateTrainingDayDto,
  ) {
    this.logger.log(`Updating training day ${id}`);
    return this.trainingDayService.updateTrainingDay(id, dto);
  }

  @Patch(':id/complete')
  @ApiOperation({
    summary: 'Mark training day as completed (helper)',
    description:
      'Quick helper route to mark a day as completed without feedback.',
  })
  @ApiParam({ name: 'id', type: Number })
  async complete(@Param('id', ParseIntPipe) id: number) {
    this.logger.log(`Marking training day ${id} as completed`);
    return this.trainingDayService.markAsCompleted(id);
  }
}
