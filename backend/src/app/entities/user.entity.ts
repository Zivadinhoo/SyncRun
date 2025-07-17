import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  ManyToOne,
  OneToMany,
  JoinColumn,
} from 'typeorm';
import { AssignedPlan } from './assigned-plan.entity';
import { TrainingPlanAi } from './training-plan-ai.entity';

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

  @OneToMany(() => AssignedPlan, (plan) => plan.athlete)
  assignedPlans: AssignedPlan[];

  @OneToMany(() => TrainingPlanAi, (plan) => plan.user)
  aiTrainingPlans: TrainingPlanAi[];

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
