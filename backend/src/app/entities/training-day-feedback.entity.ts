import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { User } from './user.entity';
import { TrainingDay } from './training-day.entity';

export enum Mood {
  GREAT = 'GREAT',
  GOOD = 'GOOD',
  NEUTRAL = 'NEUTRAL',
  BAD = 'BAD',
  TERRIBLE = 'TERRIBLE',
}

@Entity()
export class TrainingDayFeedback {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  userId: number;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'userId' })
  user: User;

  @Column()
  trainingDayId: number;

  @ManyToOne(() => TrainingDay, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'trainingDayId' })
  trainingDay: TrainingDay;

  @Column({ type: 'text' })
  comment: string;

  @Column({ type: 'int', default: 0 })
  rating: number;

  @Column({ type: 'int', nullable: true })
  rpe?: number;

  @Column({ type: 'int', nullable: true })
  duration?: number; // in minutes

  @Column({ type: 'float', nullable: true })
  distance?: number; // in kilometers

  @Column({ type: 'float', nullable: true })
  tss?: number;

  @Column({ type: 'enum', enum: Mood, nullable: true })
  mood?: Mood;

  @Column({ type: 'float', nullable: true })
  sleepHours?: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @DeleteDateColumn()
  deletedAt?: Date;
}
