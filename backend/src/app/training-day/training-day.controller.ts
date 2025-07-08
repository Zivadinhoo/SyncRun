import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Param,
  Body,
  ParseIntPipe,
  BadRequestException,
  Query,
} from '@nestjs/common';
import { TrainingDayService } from './training-day.service';
import { UpdateTrainingDayDto } from './dto/update-training-day.dto';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiParam,
  ApiQuery,
} from '@nestjs/swagger';
import { GetWeeklySummaryDto } from './dto/get-weekly-summary.dto';
import { Logger } from 'nestjs-pino';

@ApiTags('Training Days')
@ApiBearerAuth('access-token')
@Controller('training-days')
export class TrainingDayController {
  constructor(
    private readonly trainingDayService: TrainingDayService,
    private readonly logger: Logger,
  ) {}

  @Patch(':id/complete')
  @ApiOperation({ summary: 'Mark training day as completed' })
  @ApiParam({ name: 'id', type: Number })
  async complete(@Param('id', ParseIntPipe) id: number) {
    this.logger.log(`Marking training day ${id} as completed`);
    return await this.trainingDayService.markAsCompleted(id);
  }

  @Post('generate')
  @ApiOperation({
    summary: 'Generate training days from AI plan into assigned plan',
  })
  @ApiQuery({ name: 'trainingPlanId', required: true, type: Number })
  @ApiQuery({ name: 'assignedPlanId', required: true, type: Number })
  async generateFromAiPlan(
    @Query('trainingPlanId', ParseIntPipe) trainingPlanId: number,
    @Query('assignedPlanId', ParseIntPipe) assignedPlanId: number,
  ) {
    return await this.trainingDayService.generateFromAiPlan(
      trainingPlanId,
      assignedPlanId,
    );
  }

  @Get('weekly-summary')
  @ApiOperation({ summary: 'Get weekly summary of training days for athlete' })
  @ApiQuery({ name: 'startDate', required: true, type: String })
  @ApiQuery({ name: 'endDate', required: true, type: String })
  @ApiQuery({ name: 'athleteId', required: false, type: Number })
  async getWeeklySummary(@Query() dto: GetWeeklySummaryDto): Promise<any> {
    if (new Date(dto.startDate) > new Date(dto.endDate)) {
      throw new BadRequestException('startDate must be before endDate');
    }

    return await this.trainingDayService.getWeeklySummary(dto);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get training day by ID' })
  @ApiParam({ name: 'id', type: Number })
  async findOne(@Param('id', ParseIntPipe) id: number) {
    return await this.trainingDayService.findOne(id);
  }

  @Get('/by-assigned-plan/:assignedPlanId')
  @ApiOperation({ summary: 'Get all training days for an assigned plan' })
  @ApiParam({ name: 'assignedPlanId', type: Number })
  async findByAssignedPlan(
    @Param('assignedPlanId', ParseIntPipe) assignedPlanId: number,
  ) {
    return await this.trainingDayService.findByAssignedPlanId(assignedPlanId);
  }

  @Get('/by-ai-plan/:planId')
  @ApiOperation({ summary: 'Get all training days for an AI plan' })
  @ApiParam({ name: 'planId', type: Number })
  async findByAiPlan(@Param('planId', ParseIntPipe) planId: number) {
    return await this.trainingDayService.findByAiPlanId(planId);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update a training day by ID' })
  @ApiParam({ name: 'id', type: Number })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateTrainingDayDto,
  ) {
    return await this.trainingDayService.updateTrainingDay(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete (soft) training day by ID' })
  @ApiParam({ name: 'id', type: Number })
  async remove(@Param('id', ParseIntPipe) id: number) {
    return await this.trainingDayService.softDelete(id);
  }
}
