import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  Delete,
  Patch,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { PlanTemplateService } from './plan-template.service';
import { CreatePlanTemplateDto } from './dto/create-plan-template.dto';
import { UpdatePlanTemplateDto } from './dto/update-plan-template.dto';
import { Logger } from 'nestjs-pino';

@Controller('plan-templates')
export class PlanTemplateController {
  constructor(
    private readonly service: PlanTemplateService,
    private readonly logger: Logger,
  ) {}

  @Get()
  async findAll() {
    try {
      const result = await this.service.findAll();
      return result;
    } catch (error) {
      this.logger.error('Failed to fetch all plan templates');
      throw new HttpException(
        'Internal Server Error',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    try {
      return await this.service.findOne(id);
    } catch (error) {
      this.logger.warn(`Failed to fetch plan with ID ${id}`, { error });
      throw new HttpException('Plan template not found', HttpStatus.NOT_FOUND);
    }
  }

  @Post()
  async create(@Body() dto: CreatePlanTemplateDto) {
    try {
      const created = await this.service.create(dto);
      this.logger.log(`Plan template created: ${created.id}`);
      return created;
    } catch (error) {
      this.logger.error('Failed to fetch template', { error });
      throw new HttpException(
        'Failed to create plan template',
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() dto: UpdatePlanTemplateDto) {
    try {
      const updated = await this.service.update(id, dto);
      this.logger.log(`Plan template updated: ${id}`);
      return updated;
    } catch (error) {
      this.logger.error(`Failed to update plan template ${id}`, { error });
      throw new HttpException(
        'Failed to update plan template',
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    try {
      await this.service.remove(id);
      this.logger.log(`Plan template deleted: ${id}`);
      return { message: 'Deleted successfully' };
    } catch (error) {
      this.logger.error(`Failed to delete plan template ${id}`, { error });
      throw new HttpException(
        'Failed to delete plan template',
        HttpStatus.NOT_FOUND,
      );
    }
  }
}
