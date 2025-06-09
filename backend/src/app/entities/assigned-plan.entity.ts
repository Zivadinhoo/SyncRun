import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  DeleteDateColumn,
  JoinColumn,
  OneToOne,
} from 'typeorm';
import { User } from './user.entity';
import { TrainingPlan } from './training-plan.entity';
import { TrainingDay } from './training-day.entity';

@Entity()
export class AssignedPlan {
  @PrimaryGeneratedColumn()
  id: number;

  @OneToOne(() => TrainingDay, (td) => td.assignedPlan)
  trainingDay: TrainingDay;

  @Column({ nullable: true })
  feedback?: string;

  @Column()
  athleteId: number;

  @Column({ type: 'float', nullable: true })
  rpe?: number;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'athleteId' })
  athlete: User;

  @Column()
  trainingPlanId: number;

  @ManyToOne(() => TrainingPlan, { eager: false })
  @JoinColumn({ name: 'trainingPlanId' })
  trainingPlan: TrainingPlan;

  @Column({ default: false })
  isCompleted: boolean;

  @CreateDateColumn()
  assignedAt: Date;

  @DeleteDateColumn()
  deletedAt?: Date;
}
