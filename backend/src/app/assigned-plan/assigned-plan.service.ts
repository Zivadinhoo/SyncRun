// assigned-plan.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AssignedPlan } from '../entities/assigned-plan.entity';
import { TrainingPlan } from '../entities/training-plan.entity';
import { TrainingDay } from '../entities/training-day.entity';
import { CreateAssignedPlanDto } from './dto/create-assigned-plan-dto';
import { UpdateAssignedPlanDto } from './dto/update-assigned-plan.dto';
import { User } from '../entities/user.entity';
import { PlanTemplate } from '../entities/plan-template.entity';
import { PlanTemplateWeek } from '../entities/plan-template-week.entity';
import { PlanTemplateDay } from '../entities/plan-template-day.entity';

@Injectable()
export class AssignedPlanService {
  constructor(
    @InjectRepository(AssignedPlan)
    private assignedPlanRepo: Repository<AssignedPlan>,

    @InjectRepository(TrainingPlan)
    private trainingPlanRepo: Repository<TrainingPlan>,

    @InjectRepository(TrainingDay)
    private trainingDayRepo: Repository<TrainingDay>,

    @InjectRepository(PlanTemplate)
    private templateRepo: Repository<PlanTemplate>,

    @InjectRepository(PlanTemplateWeek)
    private weekRepo: Repository<PlanTemplateWeek>,

    @InjectRepository(PlanTemplateDay)
    private dayRepo: Repository<PlanTemplateDay>,
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

    const saveAssigned = await this.assignedPlanRepo.save(assigned);

    await this.trainingDayRepo.save({
      assignedPlan: { id: saveAssigned.id },
      trainingPlan: { id: plan.id },
      dayNumber: 1,
      title: 'First Training Day',
      date: dto.startDate,
    });

    return saveAssigned;
  }

  async assignFromTemplate(
    templateId: string,
    athleteId: number,
    startDate: Date,
    coachId: number,
  ): Promise<AssignedPlan> {
    const template = await this.templateRepo.findOne({
      where: { id: templateId.toString() },
      relations: ['weeks', 'weeks.days'],
    });

    if (!template) {
      throw new NotFoundException('Template not found');
    }

    const trainingPlan = await this.trainingPlanRepo.save(
      this.trainingPlanRepo.create({
        name: template.name,
        description: template.description,
        coach: { id: coachId },
      }),
    );

    const assigned = await this.assignedPlanRepo.save(
      this.assignedPlanRepo.create({
        athlete: { id: athleteId },
        trainingPlan,
        assignedAt: startDate,
      }),
    );

    const trainingDays: TrainingDay[] = [];

    for (const week of template.weeks) {
      for (const day of week.days) {
        const date = new Date(startDate);
        const offset = (week.weekNumber - 1) * 7 + (day.dayOfWeek - 1);
        date.setDate(date.getDate() + offset);

        trainingDays.push(
          this.trainingDayRepo.create({
            title: day.title,
            description: day.description,
            date: date.toISOString().split('T')[0],
            duration: day.duration,
            tss: day.tss,
            rpe: day.rpe,
            dayNumber: offset + 1,
            assignedPlan: assigned,
            trainingPlan: trainingPlan,
          }),
        );
      }
    }

    await this.trainingDayRepo.save(trainingDays);

    return assigned;
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
    const rawPlans = await this.assignedPlanRepo
      .createQueryBuilder('ap')
      .leftJoin('ap.trainingPlan', 'tp')
      .leftJoin('training_day', 'td', 'td."assignedPlanId" = ap.id')
      .select([
        'ap.id AS id',
        'ap.assignedAt AS assignedat',
        'ap.isCompleted AS iscompleted',
        'tp.id AS planid',
        'tp.name AS planname',
        'tp.description AS plandesc',
        'td.id AS trainingdayid',
      ])
      .where('ap.athleteId = :athleteId', { athleteId })
      .andWhere('ap.deletedAt IS NULL')
      .andWhere('tp.id IS NOT NULL')
      .getRawMany();

    return rawPlans.map((row) => ({
      id: row.id,
      assignedAt: row.assignedat,
      isCompleted: row.iscompleted,
      trainingPlan: row.planid
        ? {
            id: row.planid,
            name: row.planname,
            description: row.plandesc,
          }
        : null,
      trainingDayId: row.trainingdayid ?? null,
    }));
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
      ...(dto.isCompleted !== undefined && { isCompleted: dto.isCompleted }),
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
