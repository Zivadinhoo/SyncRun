import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
} from 'typeorm';
import { TrainingPlan } from './training-plan.entity';
import { AssignedPlan } from './assigned-plan.entity';

@Entity()
export class TrainingDay {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  dayNumber: number;

  @Column()
  title: string;

  @Column({ nullable: true })
  description?: string;

  @Column({ type: 'date' })
  date: string;

  @ManyToOne(() => TrainingPlan, (plan) => plan.trainingDays, {
    onDelete: 'CASCADE',
  })
  trainingPlan: TrainingPlan;

  @ManyToOne(() => AssignedPlan, { nullable: true, onDelete: 'CASCADE' })
  assignedPlan?: AssignedPlan;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @DeleteDateColumn()
  deletedAt?: Date;
}
