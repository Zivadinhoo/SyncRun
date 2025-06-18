import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  DeleteDateColumn,
  JoinColumn,
  OneToMany,
} from 'typeorm';
import { User } from './user.entity';
import { TrainingDay } from './training-day.entity';

export enum TrainingLevel {
  BEGINNER = 'BEGINNER',
  INTERMEDIATE = 'INTERMEDIATE',
  ADVANCED = 'ADVANCED',
}

@Entity()
export class TrainingPlan {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column({ type: 'text' })
  description: string;

  @OneToMany(() => TrainingDay, (day) => day.trainingPlan, {
    cascade: true,
  })
  trainingDays: TrainingDay[];

  @ManyToOne(() => User, (user) => user.trainingPlans, {
    eager: false,
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'coachId' })
  coach: User;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @DeleteDateColumn()
  deletedAt?: Date;
}
