import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  DeleteDateColumn,
  JoinColumn,
  OneToOne,
  OneToMany,
} from 'typeorm';
import { User } from './user.entity';
import { TrainingPlan } from './training-plan.entity';
import { TrainingDay } from './training-day.entity';

@Entity()
export class AssignedPlan {
  @PrimaryGeneratedColumn()
  id: number;

  @OneToMany(() => TrainingDay, (td) => td.assignedPlan)
  trainingDays: TrainingDay[];

  @Column({ nullable: true })
  feedback?: string;

  @Column()
  athleteId: number;

  @Column({ type: 'float', nullable: true })
  rpe?: number;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
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
