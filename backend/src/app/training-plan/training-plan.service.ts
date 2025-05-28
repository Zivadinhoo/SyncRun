import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TrainingPlan } from '../entities/training-plan.entity';
import { CreateTrainingPlanDto } from './dto/create-training-plan.dto';
import { UpdateTrainingPlanDto } from './dto/update-training-plan.dto';
import { UserRole } from '../entities/user.entity';
import { User } from '../entities/user.entity';

@Injectable()
export class TrainingPlanService {
  constructor(
    @InjectRepository(TrainingPlan)
    private readonly trainingPlanRepo: Repository<TrainingPlan>,
  ) {}

  async create(dto: CreateTrainingPlanDto, coach: User) {
    if (coach.role !== UserRole.COACH) {
      throw new ForbiddenException('Only coaches can create training plan');
    }

    const plan = this.trainingPlanRepo.create({
      name: dto.name,
      description: dto.description,
      coach,
    });
    return await this.trainingPlanRepo.save(plan);
  }

  async findByCoach(coachId: number) {
    return this.trainingPlanRepo.find({
      where: {
        coach: { id: coachId },
      },
      relations: ['coach'],
      order: {
        createdAt: 'DESC',
      },
    });
  }

  async findAll() {
    return this.trainingPlanRepo.find({ relations: ['coach'] });
  }

  async findOne(id: number) {
    const plan = await this.trainingPlanRepo.findOne({
      where: { id },
      relations: ['coach'],
    });
    if (!plan) throw new NotFoundException('Plan not found');
    return plan;
  }
  async update(id: number, dto: UpdateTrainingPlanDto, coach: User) {
    console.log('📌 Coach in update:', coach); // <== dodaj ovo

    let plan = await this.trainingPlanRepo.findOne({
      where: { id },
      relations: ['coach'],
    });

    if (!plan) throw new NotFoundException('Plan not found');

    if (plan.coach.id !== coach.id) {
      throw new ForbiddenException('You can only update your plan');
    }

    plan = { ...plan, ...dto };
    return this.trainingPlanRepo.save(plan);
  }

  async softDelete(id: number, coach: User) {
    const plan = await this.trainingPlanRepo.findOne({
      where: { id },
      relations: ['coach'],
    });
    if (!plan) throw new NotFoundException('Plan not found');
    if (plan.coach.id !== coach.id) {
      throw new ForbiddenException('You can only delete your plan');
    }
    await this.trainingPlanRepo.softDelete(id);
    return { deleted: true };
  }
}
