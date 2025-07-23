import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  OneToMany,
  ManyToOne,
} from 'typeorm';
import { AssignedPlan } from './assigned-plan.entity';
import { TrainingDay } from './training-day.entity';
import { User } from './user.entity';
import { GoalType } from '../common/enums/goal-type.enum'; // 👈 Dodaj import

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
  goalRaceDistance?: string;

  @Column({ nullable: true })
  generatedByModel?: string;

  @Column({ type: 'jsonb', nullable: true })
  metadata?: any;

  @Column({ type: 'enum', enum: GoalType })
  goalTag: GoalType;

  @Column()
  goalText: string;

  // Relationships
  @OneToMany(() => AssignedPlan, (assignedPlan) => assignedPlan.aiTrainingPlan)
  assignedPlans: AssignedPlan[];

  @OneToMany(() => TrainingDay, (day) => day.aiTrainingPlan)
  trainingDays: TrainingDay[];

  @ManyToOne(() => User, (user) => user.aiTrainingPlans, {
    onDelete: 'CASCADE',
  })
  user: User;

  @Column()
  userId: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @DeleteDateColumn()
  deletedAt?: Date;
}
