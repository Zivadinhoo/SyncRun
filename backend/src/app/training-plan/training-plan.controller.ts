import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  UseGuards,
  Req,
  ParseIntPipe,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { TrainingPlanService } from './training-plan.service';
import { CreateTrainingPlanDto } from './dto/create-training-plan.dto';
import { UpdateTrainingPlanDto } from './dto/update-training-plan.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PinoLogger } from 'nestjs-pino';
import { RequestWithUser } from '../common/types/request-with-user';
import { ApiTags, ApiBearerAuth, ApiOperation } from '@nestjs/swagger';

@ApiTags('Training Plans')
@ApiBearerAuth()
@Controller('training-plans')
@UseGuards(JwtAuthGuard)
export class TrainingPlanController {
  constructor(
    private readonly service: TrainingPlanService,
    private readonly logger: PinoLogger,
  ) {
    this.logger.setContext(TrainingPlanController.name);
  }

  @Post()
  @ApiOperation({ summary: 'Create a new training plan (Coach only)' })
  async create(
    @Body() dto: CreateTrainingPlanDto,
    @Req() req: RequestWithUser,
  ) {
    try {
      this.logger.info(
        { dto, userId: req.user.id },
        '📦 Creating training plan',
      );
      return await this.service.create(dto, req.user);
    } catch (error) {
      this.logger.error(
        { error, userId: req.user.id },
        '❌ Error creating training plan',
      );
      throw new HttpException(
        'Failed to create a plan',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get()
  @ApiOperation({ summary: 'Get all training plans' })
  async findAll() {
    try {
      this.logger.info('📄 Getting all training plans');
      return await this.service.findAll();
    } catch (error) {
      this.logger.error({ error }, '❌ Error fetching training plans');
      throw new HttpException(
        'Failed to fetch plans',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a specific training plan by ID' })
  async findOne(@Param('id', ParseIntPipe) id: number) {
    try {
      this.logger.info({ id }, '🔍 Getting single training plan');
      return await this.service.findOne(id);
    } catch (err) {
      this.logger.error({ err, id }, '❌ Error fetching plan');
      throw new HttpException(
        'Failed to fetch plan',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update your own training plan (Coach only)' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateTrainingPlanDto,
    @Req() req: RequestWithUser,
  ) {
    try {
      this.logger.info(
        { id, dto, userId: req.user.id },
        '✏️ Updating training plan',
      );
      return await this.service.update(id, dto, req.user);
    } catch (error) {
      this.logger.error(
        { error, id, userId: req.user.id },
        '❌ Error updating plan',
      );
      throw new HttpException(
        'Failed to update plan',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Soft delete your own training plan (Coach only)' })
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @Req() req: RequestWithUser,
  ) {
    try {
      this.logger.info(
        { id, userId: req.user.id },
        '🗑 Soft deleting training plan',
      );
      return await this.service.softDelete(id, req.user);
    } catch (error) {
      this.logger.error(
        { error, id, userId: req.user.id },
        '❌ Error deleting plan',
      );
      throw new HttpException(
        'Failed to delete plan',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
