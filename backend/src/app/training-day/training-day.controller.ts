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
import { CreateTrainingDayDto } from './dto/create-training-day.dto';
import { UpdateTrainingDayDto } from './dto/update-training-day.dto';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiParam,
  ApiQuery,
} from '@nestjs/swagger';
import { CreateTrainingDayBulkDto } from './dto/create-training-day-bulk.dto';
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

  @Post()
  @ApiOperation({ summary: 'Create a training day' })
  async create(@Body() dto: CreateTrainingDayDto) {
    const exists = await this.trainingDayService.existsByDayNumber(
      dto.trainingPlanId,
      dto.dayNumber,
    );

    if (exists) {
      throw new BadRequestException(
        `Day ${dto.dayNumber} already exists in this plan`,
      );
    }

    return this.trainingDayService.create(dto);
  }

  @Post('bulk')
  @ApiOperation({ summary: 'Create multiple training days in bulk' })
  async createBulk(@Body() dto: CreateTrainingDayBulkDto) {
    return await this.trainingDayService.createBulk(dto);
  }

  @Get('weekly-summary')
  @ApiQuery({
    name: 'startDate',
    required: true,
    type: String,
    example: '2025-06-10',
  })
  @ApiQuery({
    name: 'endDate',
    required: true,
    type: String,
    example: '2025-06-16',
  })
  @ApiQuery({ name: 'athleteId', required: false, type: Number, example: 4 })
  @ApiOperation({ summary: 'Get weekly summary of training days for athlete' })
  async getWeeklySummary(@Query() dto: GetWeeklySummaryDto): Promise<any> {
    try {
      if (new Date(dto.startDate) > new Date(dto.endDate)) {
        throw new BadRequestException('startDate must be before endDate');
      }

      this.logger.log(
        `Fetching weekly summary for athleteId=${dto.athleteId ?? 'N/A'} from ${dto.startDate} to ${dto.endDate}`,
      );

      const summary = await this.trainingDayService.getWeeklySummary(dto);

      this.logger.debug(
        `Weekly summary result: ${JSON.stringify(summary, null, 2)}`,
      );

      return summary;
    } catch (error) {
      this.logger.error(
        `Failed to get weekly summary: ${error.message}`,
        error.stack,
      );
      throw error;
    }
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get training day by ID' })
  @ApiParam({ name: 'id', type: Number })
  async findOne(@Param('id', ParseIntPipe) id: number) {
    return await this.trainingDayService.findOne(id);
  }

  @Get('/by-plan/:planId')
  @ApiOperation({ summary: 'Get all training days for a plan' })
  @ApiParam({ name: 'planId', type: Number })
  async findByPlan(@Param('planId', ParseIntPipe) planId: number) {
    return await this.trainingDayService.findByTrainingPlanId(planId);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update a training day by ID' })
  @ApiParam({ name: 'id', type: Number })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateTrainingDayDto,
  ) {
    return await this.trainingDayService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete (soft) training day by ID' })
  @ApiParam({ name: 'id', type: Number })
  async remove(@Param('id', ParseIntPipe) id: number) {
    return await this.trainingDayService.softDelete(id);
  }
}
