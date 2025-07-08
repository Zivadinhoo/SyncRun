import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  CreateDateColumn,
  DeleteDateColumn,
  JoinColumn,
} from 'typeorm';
import { User } from './user.entity';
import { TrainingDay } from './training-day.entity';
import { TrainingPlanAi } from './training-plan-ai.entity';

@Entity()
export class AssignedPlan {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  athleteId: number;

  @ManyToOne(() => User, (user) => user.assignedPlans, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'athleteId' })
  athlete: User;

  @OneToMany(() => TrainingDay, (td) => td.assignedPlan, { cascade: true })
  trainingDays: TrainingDay[];

  @Column({ nullable: true })
  aiTrainingPlanId: number;

  @ManyToOne(() => TrainingPlanAi, (plan) => plan.assignedPlans, {
    nullable: true,
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'aiTrainingPlanId' })
  aiTrainingPlan: TrainingPlanAi;

  // ✅ TEMPORARY: allow null to avoid migration crash
  @Column({ nullable: true })
  planName?: string;

  @Column({ nullable: true })
  planGoal?: string;

  @Column({ type: 'int', nullable: true })
  durationInWeeks?: number;

  @Column({ default: false })
  isCompleted: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @DeleteDateColumn()
  deletedAt?: Date;
}
