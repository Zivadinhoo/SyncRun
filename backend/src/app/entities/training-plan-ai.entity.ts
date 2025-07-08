import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  OneToMany,
} from 'typeorm';
import { AssignedPlan } from './assigned-plan.entity';
import { TrainingDay } from './training-day.entity';

@Entity('training_plan_ai')
export class TrainingPlanAi {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column({ nullable: true, type: 'text' })
  description?: string;

  @Column({ type: 'int', nullable: true })
  durationInWeeks?: number;

  @Column({ nullable: true })
  goalRaceDistance?: string; // e.g. "5k", "10k", "Half Marathon", "Marathon"

  @Column({ nullable: true })
  generatedByModel?: string; // e.g. "gpt-4", "custom-ai", etc.

  @Column({ type: 'jsonb', nullable: true })
  metadata?: any; // e.g. { basedOn: "previous plan", intensity: "moderate" }

  @OneToMany(() => AssignedPlan, (assignedPlan) => assignedPlan.aiTrainingPlan)
  assignedPlans: AssignedPlan[];

  @OneToMany(() => TrainingDay, (day) => day.aiTrainingPlan)
  trainingDays: TrainingDay[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @DeleteDateColumn()
  deletedAt?: Date;
}
