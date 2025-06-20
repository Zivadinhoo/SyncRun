import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PlanTemplate } from '../entities/plan-template.entity';
import { PlanTemplateWeek } from '../entities/plan-template-week.entity';
import { CreatePlanTemplateDto } from './dto/create-plan-template.dto';
import { UpdatePlanTemplateDto } from './dto/update-plan-template.dto';

@Injectable()
export class PlanTemplateService {
  constructor(
    @InjectRepository(PlanTemplate)
    private readonly templateRepo: Repository<PlanTemplate>,
    @InjectRepository(PlanTemplateWeek)
    private readonly weekRepo: Repository<PlanTemplateWeek>,
  ) {}

  async create(dto: CreatePlanTemplateDto): Promise<PlanTemplate> {
    const template = this.templateRepo.create({
      ...dto,
      weeks: dto.weeks,
    });
    return this.templateRepo.save(template);
  }

  async findAll(): Promise<PlanTemplate[]> {
    return this.templateRepo.find({ relations: ['weeks'] });
  }

  async findOne(id: string): Promise<PlanTemplate> {
    const template = await this.templateRepo.findOne({
      where: { id },
      relations: ['weeks'],
    });

    if (!template) {
      throw new NotFoundException('Plan template not found');
    }

    return template;
  }

  async update(id: string, dto: UpdatePlanTemplateDto): Promise<PlanTemplate> {
    const template = await this.findOne(id);
    Object.assign(template, dto);
    return this.templateRepo.save(template);
  }

  async remove(id: string): Promise<void> {
    const found = await this.templateRepo.findOne({ where: { id } });
    if (!found) throw new NotFoundException('Plan template not found');
    await this.templateRepo.delete(id);
  }
}
