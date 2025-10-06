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

  async findOne(id: number): Promise<TrainingDay> {
    const day = await this.trainingDayRepository.findOneBy({ id });
    if (!day) throw new NotFoundException('Training day not found');
    return day;
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
        distance: templateDay.distance,
        status: 'upcoming',
        date: templateDay.date,
        assignedPlan,
        aiTrainingPlan: aiPlan,
      }),
    );

    return this.trainingDayRepository.save(generatedDays);
  }
}
