import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TrainingDay } from '../entities/training-day.entity';
import { CreateTrainingDayDto } from './dto/create-training-day.dto';
import { UpdateTrainingDayDto } from './dto/update-training-day.dto';
import { TrainingPlan } from '../entities/training-plan.entity';
import { CreateTrainingDayBulkDto } from './dto/create-training-day-bulk.dto';

@Injectable()
export class TrainingDayService {
  constructor(
    @InjectRepository(TrainingDay)
    private trainingDayRepo: Repository<TrainingDay>,

    @InjectRepository(TrainingPlan)
    private trainingPlanRepo: Repository<TrainingPlan>,
  ) {}

  async create(dto: CreateTrainingDayDto): Promise<TrainingDay> {
    const trainingPlan = await this.trainingPlanRepo.findOne({
      where: { id: dto.trainingPlanId },
    });

    if (!trainingPlan) {
      throw new NotFoundException('Training Plan not found');
    }

    const trainingDay = this.trainingDayRepo.create({
      ...dto,
      trainingPlan,
    });

    return this.trainingDayRepo.save(trainingDay);
  }

  async createBulk(dto: CreateTrainingDayBulkDto): Promise<TrainingDay[]> {
    const { items } = dto;

    const planId = items[0]?.trainingPlanId;
    if (!planId) throw new BadRequestException('Missing trainingPlanId');

    const trainingPlan = await this.trainingPlanRepo.findOne({
      where: { id: planId },
    });

    if (!trainingPlan) {
      throw new NotFoundException('Training Plan not found');
    }

    const existingDays = await this.trainingDayRepo.find({
      where: { trainingPlan: { id: planId } },
    });

    const existingDayNumbers = new Set(existingDays.map((d) => d.dayNumber));
    const duplicateInDb = items.find((item) =>
      existingDayNumbers.has(item.dayNumber),
    );

    if (duplicateInDb) {
      throw new BadRequestException(
        `Day ${duplicateInDb.dayNumber} already exists in this plan`,
      );
    }

    const entities = items.map((dto) => {
      const day = new TrainingDay();
      day.dayNumber = dto.dayNumber;
      day.title = dto.title;
      day.description = dto.description;
      day.trainingPlan = trainingPlan;
      return day;
    });

    return this.trainingDayRepo.save(entities);
  }

  async existsByDayNumber(
    trainingPlanId: number,
    dayNumber: number,
  ): Promise<boolean> {
    const existing = await this.trainingDayRepo.findOne({
      where: {
        trainingPlan: { id: trainingPlanId },
        dayNumber,
      },
    });

    return !!existing;
  }

  findAll(): Promise<TrainingDay[]> {
    return this.trainingDayRepo.find({
      relations: ['trainingPlan'],
      order: { dayNumber: 'ASC' },
    });
  }

  async findByTrainingPlanId(planId: number): Promise<TrainingDay[]> {
    return this.trainingDayRepo.find({
      where: { trainingPlan: { id: planId } },
      relations: ['trainingPlan'],
      order: { dayNumber: 'ASC' },
    });
  }

  async findOne(id: number): Promise<TrainingDay> {
    const trainingDay = await this.trainingDayRepo.findOne({
      where: { id },
      relations: ['trainingPlan'],
    });

    if (!trainingDay) {
      throw new NotFoundException('Training Day not found');
    }

    return trainingDay;
  }

  async update(id: number, dto: UpdateTrainingDayDto): Promise<TrainingDay> {
    const trainingDay = await this.findOne(id);

    const updated = this.trainingDayRepo.merge(trainingDay, {
      ...dto,
    });

    return this.trainingDayRepo.save(updated);
  }

  async softDelete(id: number): Promise<void> {
    const result = await this.trainingDayRepo.softDelete(id);

    if (result.affected === 0) {
      throw new NotFoundException('Training Day not found');
    }
  }
}
