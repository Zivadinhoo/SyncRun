import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  JoinColumn,
} from 'typeorm';
import { AssignedPlan } from './assigned-plan.entity';
import { TrainingPlanAi } from './training-plan-ai.entity';
import { TrainingStatus } from '../common/types/training-status.type';

@Entity()
export class TrainingDay {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ nullable: true })
  dayNumber?: number; // može ostati ako ga koristiš za sortiranje

  @Column({
    type: 'enum',
    enum: ['upcoming', 'completed', 'missed'],
    default: 'upcoming',
  })
  status: TrainingStatus;

  @Column({ type: 'float', nullable: true })
  distance?: number;

  @Column({ type: 'int', nullable: true })
  rpe?: number;

  @Column()
  title: string;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column({ type: 'date' })
  date: string;

  @Column()
  assignedPlanId: number;

  @ManyToOne(() => AssignedPlan, (plan) => plan.trainingDays, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'assignedPlanId' })
  assignedPlan: AssignedPlan;

  @Column({ nullable: true })
  aiTrainingPlanId?: number;

  @ManyToOne(() => TrainingPlanAi, (plan) => plan.trainingDays, {
    nullable: true,
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'aiTrainingPlanId' })
  aiTrainingPlan: TrainingPlanAi;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @DeleteDateColumn()
  deletedAt?: Date;
}
