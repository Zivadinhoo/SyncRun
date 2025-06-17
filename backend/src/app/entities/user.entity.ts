import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { TrainingPlan } from './training-plan.entity';

export enum UserRole {
  COACH = 'coach',
  ATHLETE = 'athlete',
}

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  firstName: string;

  @Column()
  lastName: string;

  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @Column({ type: 'enum', enum: UserRole, default: UserRole.ATHLETE })
  role: UserRole;

  @OneToMany(() => TrainingPlan, (plan) => plan.coach)
  trainingPlans: TrainingPlan[];

  @ManyToOne(() => User, (coach) => coach.athletes, { nullable: true })
  @JoinColumn({ name: 'coachId' })
  coach: User;

  @OneToMany(() => User, (athlete) => athlete.coach)
  athletes: User[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @Column({ default: false })
  isDeleted: boolean;
}
