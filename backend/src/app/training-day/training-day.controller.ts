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
} from '@nestjs/common';
import { TrainingDayService } from './training-day.service';
import { CreateTrainingDayDto } from './dto/create-training-day.dto';
import { UpdateTrainingDayDto } from './dto/update-training-day.dto';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiParam,
} from '@nestjs/swagger';
import { CreateTrainingDayBulkDto } from './dto/create-training-day-bulk.dto';

@ApiTags('Training Days')
@ApiBearerAuth('access-token')
@Controller('training-days')
export class TrainingDayController {
  constructor(private readonly trainingDayService: TrainingDayService) {}

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

  @Get()
  @ApiOperation({ summary: 'Get all training days' })
  findAll() {
    return this.trainingDayService.findAll();
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
