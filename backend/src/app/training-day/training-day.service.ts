import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TrainingDay } from '../entities/training-day.entity';
import { AssignedPlan } from '../entities/assigned-plan.entity';
import { TrainingPlanAi } from '../entities/training-plan-ai.entity';

@Injectable()
export class TrainingDayService {
  constructor(
    @InjectRepository(TrainingDay)
    private trainingDayRepository: Repository<TrainingDay>,

    @InjectRepository(AssignedPlan)
    private assignedPlanRepository: Repository<AssignedPlan>,

    @InjectRepository(TrainingPlanAi)
    private aiPlanRepository: Repository<TrainingPlanAi>,
  ) {}

  async findByAiPlanId(planId: number): Promise<TrainingDay[]> {
    return this.trainingDayRepository.find({
      where: { aiTrainingPlan: { id: planId } },
    });
  }

  async findByAssignedPlanId(assignedPlanId: number): Promise<TrainingDay[]> {
    return this.trainingDayRepository.find({
      where: { assignedPlan: { id: assignedPlanId } },
    });
  }

  async updateTrainingDay(
    id: number,
    updates: Partial<TrainingDay>,
  ): Promise<TrainingDay> {
    const day = await this.trainingDayRepository.findOneBy({ id });
    if (!day) throw new NotFoundException('Training day not found');

    Object.assign(day, updates);
    return this.trainingDayRepository.save(day);
  }

  async markAsCompleted(id: number): Promise<TrainingDay> {
    const day = await this.trainingDayRepository.findOneBy({ id });
    if (!day) throw new NotFoundException('Training day not found');

    day.status = 'completed';
    return this.trainingDayRepository.save(day);
  }

  async generateFromAiPlan(
    trainingPlanId: number,
    assignedPlanId: number,
  ): Promise<TrainingDay[]> {
    const aiPlan = await this.aiPlanRepository.findOne({
      where: { id: trainingPlanId },
      relations: ['trainingDays'],
    });
    if (!aiPlan) throw new NotFoundException('AI Plan not found');

    const assignedPlan = await this.assignedPlanRepository.findOneBy({
      id: assignedPlanId,
    });
    if (!assignedPlan) throw new NotFoundException('Assigned Plan not found');

    const generatedDays = aiPlan.trainingDays.map((templateDay) =>
      this.trainingDayRepository.create({
        dayNumber: templateDay.dayNumber,
        title: templateDay.title,
        description: templateDay.description,
        duration: templateDay.duration,
        distance: templateDay.distance,
        tss: templateDay.tss,
        rpe: templateDay.rpe,
        status: 'upcoming',
        date: templateDay.date,
        assignedPlan,
        aiTrainingPlan: aiPlan,
      }),
    );

    return this.trainingDayRepository.save(generatedDays);
  }

  async deleteByAssignedPlanId(assignedPlanId: number): Promise<void> {
    await this.trainingDayRepository.delete({
      assignedPlan: { id: assignedPlanId },
    });
  }

  async findOne(id: number): Promise<TrainingDay> {
    const day = await this.trainingDayRepository.findOneBy({ id });
    if (!day) throw new NotFoundException('Training day not found');
    return day;
  }

  async softDelete(id: number): Promise<void> {
    await this.trainingDayRepository.softDelete(id);
  }

  async getWeeklySummary(dto: {
    athleteId?: number;
    startDate: string;
    endDate: string;
  }): Promise<any> {
    const { startDate, endDate, athleteId } = dto;

    const query = this.trainingDayRepository
      .createQueryBuilder('day')
      .select('COUNT(*)', 'total')
      .addSelect(
        `SUM(CASE WHEN day.status = 'completed' THEN 1 ELSE 0 END)`,
        'completed',
      )
      .addSelect('AVG(day.rpe)', 'averageRpe')
      .where('day.date BETWEEN :startDate AND :endDate', {
        startDate,
        endDate,
      });

    if (athleteId) {
      query
        .innerJoin('day.assignedPlan', 'assignedPlan')
        .andWhere('assignedPlan.athleteId = :athleteId', { athleteId });
    }

    return query.getRawOne();
  }
}
