import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AssignedPlan } from '../entities/assigned-plan.entity';
import { TrainingPlan } from '../entities/training-plan.entity';
import { CreateAssignedPlanDto } from './dto/create-assigned-plan-dto';
import { UpdateAssignedPlanDto } from './dto/update-assigned-plan.dto';
import { User } from '../entities/user.entity';

@Injectable()
export class AssignedPlanService {
  constructor(
    @InjectRepository(AssignedPlan)
    private assignedPlanRepo: Repository<AssignedPlan>,
    @InjectRepository(TrainingPlan)
    private readonly trainingPlanRepo: Repository<TrainingPlan>,
  ) {}

  async create(dto: CreateAssignedPlanDto): Promise<AssignedPlan> {
    const plan = await this.trainingPlanRepo.findOne({
      where: { id: dto.trainingPlanId },
      relations: ['coach'],
    });

    if (!plan) {
      throw new NotFoundException('Training plan is not found');
    }

    const assigned = this.assignedPlanRepo.create({
      athlete: { id: dto.athleteId } as User,
      trainingPlan: plan,
      assignedAt: new Date(dto.startDate),
    });

    return await this.assignedPlanRepo.save(assigned);
  }

  async findAllByCoach(coachId: number) {
    return this.assignedPlanRepo.find({
      where: {
        trainingPlan: {
          coach: {
            id: coachId,
          },
        },
      },
      relations: ['athlete', 'trainingPlan', 'trainingPlan.coach'],
    });
  }

  async findAllByAthlete(athleteId: number) {
    return this.assignedPlanRepo
      .createQueryBuilder('assignedPlan')
      .innerJoinAndSelect('assignedPlan.trainingPlan', 'trainingPlan')
      .where('assignedPlan.athleteId = :athleteId', { athleteId })
      .andWhere('assignedPlan.deletedAt IS NULL')
      .andWhere('trainingPlan.deletedAt IS NULL')
      .getMany();
  }

  async findOne(id: number): Promise<AssignedPlan> {
    const result = await this.assignedPlanRepo.findOne({
      where: { id },
      relations: ['athlete', 'trainingPlan'],
    });

    if (!result) throw new NotFoundException('Assigned plan not found');
    return result;
  }

  async update(id: number, dto: UpdateAssignedPlanDto): Promise<AssignedPlan> {
    const assigned = await this.findOne(id);
    const updates: Partial<AssignedPlan> = {
      ...(dto.startDate && { assignedAt: new Date(dto.startDate) }),
      ...(dto.IsCompleted !== undefined && { isCompleted: dto.IsCompleted }),
      ...(dto.feedback !== undefined && { feedback: dto.feedback }),
      ...(dto.rpe !== undefined && { rpe: dto.rpe }),
    };
    Object.assign(assigned, updates);

    return await this.assignedPlanRepo.save(assigned);
  }

  async softDelete(id: number): Promise<void> {
    await this.assignedPlanRepo.softDelete(id);
  }
}
