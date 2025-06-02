import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { TrainingDayFeedback } from '../entities/training-day-feedback.entity';
import { Repository } from 'typeorm';
import { CreateTrainingDayFeedbackDto } from './dto/create-training-day-feedback.dto';
import { UpdateTrainingDayFeedbackDto } from './dto/update-training-day-feedback.dto';
import { TrainingDay } from '../entities/training-day.entity';
import { User } from '../entities/user.entity';
import { GetTrainingDayFeedbackDto } from './dto/get-training-day-feedback.query.dto';

@Injectable()
export class TrainingDayFeedbackService {
  constructor(
    @InjectRepository(TrainingDayFeedback)
    private readonly feedbackRepo: Repository<TrainingDayFeedback>,
    @InjectRepository(TrainingDay)
    private readonly trainingDayRepo: Repository<TrainingDay>,
  ) {}

  async create(
    userId: number,
    dto: CreateTrainingDayFeedbackDto,
  ): Promise<TrainingDayFeedback> {
    const trainingDay = await this.trainingDayRepo.findOne({
      where: { id: dto.trainingDayId },
      relations: ['assignedPlan', 'assignedPlan.athlete'],
    });

    if (!trainingDay) throw new NotFoundException('Training day not found');
    if (trainingDay.assignedPlan?.athlete.id !== userId)
      throw new ForbiddenException('You are not allowed to leave feedback');

    const feedback = this.feedbackRepo.create({
      user: { id: userId } as User,
      trainingDay: { id: dto.trainingDayId } as TrainingDay,
      comment: dto.comment,
      rating: dto.rating,
    });
    return await this.feedbackRepo.save(feedback);
  }

  async findForCoach(query: GetTrainingDayFeedbackDto) {
    const qb = this.feedbackRepo
      .createQueryBuilder('feedback')
      .leftJoinAndSelect('feedback.user', 'user')
      .leftJoinAndSelect('feedback.trainingDay', 'trainingDay')
      .leftJoinAndSelect('trainingDay.assignedPlan', 'plan');

    if (query.planId) {
      qb.andWhere('plan.id = :planId', { planId: query.planId });
    }

    if (query.athleteId) {
      qb.andWhere('user.id = :athleteId', { athleteId: query.athleteId });
    }

    return qb
      .orderBy('trainingDay.date', 'ASC') // ✅ ispravan alias
      .getMany();
  }

  async findAll() {
    return this.feedbackRepo.find({ relations: ['user', 'trainingday'] });
  }

  async findOne(id: number) {
    const result = await this.feedbackRepo.findOne({
      where: { id },
      relations: ['user', 'trainingDay'],
    });
    if (!result) throw new NotFoundException('Feedback not found');
    return result;
  }

  async update(
    id: number,
    userId: number,
    dto: UpdateTrainingDayFeedbackDto,
  ): Promise<TrainingDayFeedback> {
    const feedback = await this.findOne(id);
    if (feedback.user.id !== userId) throw new ForbiddenException();

    if (dto.comment) feedback.comment = dto.comment;
    if (typeof dto.rating === 'number') feedback.rating = dto.rating;

    return this.feedbackRepo.save(feedback);
  }

  async remove(id: number, userId: number): Promise<void> {
    const feedback = await this.findOne(id);
    if (feedback.user.id !== userId)
      throw new ForbiddenException('You can only delete your own feedback');
    await this.feedbackRepo.softDelete(id);
  }

  async restore(id: number, userId: number): Promise<void> {
    const feedback = await this.feedbackRepo.findOne({
      where: { id },
      withDeleted: true,
      relations: ['user'],
    });

    if (!feedback) throw new NotFoundException('Feedback not found');
    if (feedback.user.id !== userId)
      throw new ForbiddenException('You can only restore your own feedback');
    await this.feedbackRepo.restore(id);
  }
}
