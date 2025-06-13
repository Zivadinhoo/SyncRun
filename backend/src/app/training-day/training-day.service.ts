import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Between, In, Repository } from 'typeorm';
import { TrainingDay } from '../entities/training-day.entity';
import { CreateTrainingDayDto } from './dto/create-training-day.dto';
import { UpdateTrainingDayDto } from './dto/update-training-day.dto';
import { TrainingPlan } from '../entities/training-plan.entity';
import { CreateTrainingDayBulkDto } from './dto/create-training-day-bulk.dto';
import { GetWeeklySummaryDto } from './dto/get-weekly-summary.dto';
import { TrainingDayFeedback } from '../entities/training-day-feedback.entity';

@Injectable()
export class TrainingDayService {
  constructor(
    @InjectRepository(TrainingDay)
    private trainingDayRepo: Repository<TrainingDay>,

    @InjectRepository(TrainingDayFeedback)
    private feedbackRepo: Repository<TrainingDayFeedback>,
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
  async getWeeklySummary(dto: GetWeeklySummaryDto) {
    const where: any = {
      date: Between(dto.startDate, dto.endDate),
    };

    if (dto.athleteId) {
      where.assignedPlan = {
        athlete: {
          id: dto.athleteId,
        },
      };
    }

    const days = await this.trainingDayRepo.find({
      where,
      relations: ['assignedPlan', 'assignedPlan.athlete', 'trainingPlan'],
      order: { date: 'ASC' },
    });

    const feedbacks = await this.feedbackRepo.find({
      where: {
        trainingDay: In(days.map((d) => d.id)),
      },
      relations: ['trainingDay'],
    });

    // Bezbedno pravljenje mape (da ne pukne ako trainingDay fali)
    const feedbackMap = new Map<number, TrainingDayFeedback>();
    for (const f of feedbacks) {
      if (f.trainingDay?.id) {
        feedbackMap.set(f.trainingDay.id, f);
      }
    }

    const summary = days.map((day) => {
      const feedback = feedbackMap.get(day.id);

      const rpe = feedback?.rpe ?? feedback?.rating ?? 0;
      const duration = feedback?.duration ?? day.duration ?? 0;
      const tss = rpe * duration * 0.1;

      return {
        id: day.id,
        date: day.date,
        title: day.title,
        description: day.description,
        isCompleted: !!feedback || day.assignedPlan?.isCompleted || false,
        duration,
        rating: rpe,
        comment: feedback?.comment ?? '',
        tss,
      };
    });

    const totalTSS = summary.reduce((acc, cur) => acc + cur.tss, 0);
    const completedDuration = summary
      .filter((d) => d.isCompleted)
      .reduce((acc, d) => acc + d.duration, 0);
    const avgRPE =
      summary
        .filter((d) => d.rating > 0)
        .reduce((acc, d) => acc + d.rating, 0) /
      (summary.filter((d) => d.rating > 0).length || 1);

    return {
      days: summary,
      totalTSS,
      completedDuration,
      averageRPE: Math.round(avgRPE * 10) / 10,
    };
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
