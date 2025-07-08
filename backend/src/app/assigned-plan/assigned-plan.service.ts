import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AssignedPlan } from '../entities/assigned-plan.entity';
import { TrainingPlanAi } from '../entities/training-plan-ai.entity';
import { TrainingDay } from '../entities/training-day.entity';
import { User } from '../entities/user.entity';
import { CreateAssignedPlanDto } from './dto/create-assigned-plan-dto';

@Injectable()
export class AssignedPlanService {
  constructor(
    @InjectRepository(AssignedPlan)
    private assignedPlanRepo: Repository<AssignedPlan>,

    @InjectRepository(TrainingPlanAi)
    private aiPlanRepo: Repository<TrainingPlanAi>,

    @InjectRepository(TrainingDay)
    private trainingDayRepo: Repository<TrainingDay>,

    @InjectRepository(User)
    private userRepo: Repository<User>,
  ) {}

  async create(dto: CreateAssignedPlanDto): Promise<AssignedPlan> {
    const aiPlan = await this.aiPlanRepo.findOne({
      where: { id: dto.trainingPlanId },
      relations: ['trainingDays'],
    });

    if (!aiPlan) throw new NotFoundException('AI training plan not found');

    const athlete = await this.userRepo.findOneBy({ id: dto.athleteId });
    if (!athlete) throw new NotFoundException('Athlete not found');

    const assignedPlan = this.assignedPlanRepo.create({
      athlete,
      planName: aiPlan.name,
      planGoal: aiPlan.goalRaceDistance,
      durationInWeeks: aiPlan.durationInWeeks,
    });

    const savedPlan = await this.assignedPlanRepo.save(assignedPlan);

    const startDate = new Date(dto.startDate);

    // Generate training days with calculated dates
    const generatedDays = aiPlan.trainingDays.map((day) => {
      const offsetDate = new Date(startDate);
      offsetDate.setDate(offsetDate.getDate() + (day.dayNumber - 1));

      return this.trainingDayRepo.create({
        dayNumber: day.dayNumber,
        title: day.title,
        description: day.description,
        duration: day.duration,
        distance: day.distance,
        tss: day.tss,
        rpe: day.rpe,
        status: 'upcoming',
        assignedPlan: savedPlan,
        aiTrainingPlan: aiPlan,
        date: offsetDate.toISOString().slice(0, 10), // YYYY-MM-DD
      });
    });

    await this.trainingDayRepo.save(generatedDays);

    // Set active assigned plan
    athlete.activeAssignedPlanId = savedPlan.id;
    await this.userRepo.save(athlete);

    return savedPlan;
  }

  async findAllByAthlete(userId: number): Promise<AssignedPlan[]> {
    return this.assignedPlanRepo.find({
      where: { athlete: { id: userId } },
      relations: ['trainingDays'],
    });
  }

  async findOne(id: number, userId: number): Promise<AssignedPlan> {
    const plan = await this.assignedPlanRepo.findOne({
      where: { id, athlete: { id: userId } },
      relations: ['trainingDays'],
    });
    if (!plan) throw new NotFoundException('Assigned plan not found');
    return plan;
  }

  async softDelete(id: number, userId: number): Promise<void> {
    const plan = await this.findOne(id, userId);
    await this.assignedPlanRepo.softRemove(plan);
  }
}
