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
    const assigned = this.assignedPlanRepo.create({
      athlete: { id: dto.atheleteId } as User,
      trainingPlan: { id: dto.trainingPlanId } as TrainingPlan,
      assignedAt: new Date(dto.startDate),
    });

    return await this.assignedPlanRepo.save(assigned);
  }

  async findByCoach(coachId: number): Promise<AssignedPlan[]> {
    return this.assignedPlanRepo
      .createQueryBuilder('assigned')
      .leftJoinAndSelect('assigned.trainingPlan', 'trainingPlan')
      .leftJoinAndSelect('assigned.athlete', 'athlete')
      .leftJoin('trainingPlan.coach', 'coach')
      .where('coach.id = :coachId', { coachId })
      .andWhere('assigned.deletedAt IS NULL')
      .orderBy('assigned.assignedAt', 'DESC')
      .getMany();
  }

  async findAll(): Promise<AssignedPlan[]> {
    return await this.assignedPlanRepo.find({
      relations: ['athlete', 'trainingPlan'],
    });
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

    if (dto.startDate) assigned.assignedAt = new Date(dto.startDate);
    if (dto.IsCompleted !== undefined) assigned.isCompleted = dto.IsCompleted;

    return await this.assignedPlanRepo.save(assigned);
  }

  async softDelete(id: number): Promise<void> {
    await this.assignedPlanRepo.softDelete(id);
  }
}
