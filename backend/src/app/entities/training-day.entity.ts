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

  @Column({
    type: 'enum',
    enum: ['upcoming', 'completed', 'missed'],
    default: 'upcoming',
  })
  status: 'upcoming' | 'completed' | 'missed';

  @Column({ type: 'int', nullable: true })
  duration?: number; // in minutes

  @Column({ type: 'float', nullable: true })
  distance?: number; // in kilometers

  @Column({ type: 'int', nullable: true })
  tss?: number;

  @Column({ type: 'int', nullable: true })
  rpe?: number;

  @Column()
  title: string;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column({ type: 'date' })
  date: string;

  @ManyToOne(() => TrainingPlan, (plan) => plan.trainingDays, {
    onDelete: 'CASCADE',
  })
  trainingPlan: TrainingPlan;

  @ManyToOne(() => AssignedPlan, (assignedPlan) => assignedPlan.trainingDays, {
    nullable: true,
    onDelete: 'CASCADE',
  })
  assignedPlan?: AssignedPlan;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @DeleteDateColumn()
  deletedAt?: Date;
}
