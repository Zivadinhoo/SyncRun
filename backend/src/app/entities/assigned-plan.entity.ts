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

  @ManyToOne(() => User)
  @JoinColumn({ name: 'athleteId' })
  athlete: User;

  @ManyToOne(() => TrainingPlan)
  @JoinColumn({ name: 'trainingPlanId' })
  trainingPlan: TrainingPlan;

  @Column({ default: false })
  isCompleted: boolean;

  @CreateDateColumn()
  assignedAt: Date;

  @DeleteDateColumn()
  deletedAt?: Date;
}
