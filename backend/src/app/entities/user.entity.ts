import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
  ManyToOne,
  JoinColumn,
  DeleteDateColumn,
} from 'typeorm';
import { TrainingPlan } from './training-plan.entity';
import { AssignedPlan } from './assigned-plan.entity';

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

  @ManyToOne(() => User, (coach) => coach.athletes, {
    nullable: true,
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'coachId' })
  coach: User;

  @OneToMany(() => User, (athlete) => athlete.coach)
  athletes: User[];

  @Column({ nullable: true })
  activeAssignedPlanId?: number;

  @ManyToOne(() => AssignedPlan, { nullable: true, onDelete: 'SET NULL' })
  @JoinColumn({ name: 'activeAssignedPlanId' })
  activeAssignedPlan?: AssignedPlan;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @DeleteDateColumn()
  deletedAt?: Date;

  @Column({ default: false })
  isDeleted: boolean;
}
