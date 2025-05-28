import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  DeleteDateColumn,
  JoinColumn,
} from 'typeorm';
import { User } from './user.entity';
import { TrainingPlan } from './training-plan.entity';

@Entity()
export class AssignedPlan {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, { eager: true })
  @JoinColumn({ name: 'athleteId' })
  athlete: User;

  @ManyToOne(() => TrainingPlan, { eager: true })
  @JoinColumn({ name: 'trainingPlanId' })
  trainingPlan: TrainingPlan;

  @Column({ default: false })
  isCompleted: boolean;

  @CreateDateColumn()
  assignedAt: Date;

  @DeleteDateColumn()
  deletedAt?: Date;
}
