import {
  Column,
  Entity,
  ManyToOne,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
} from 'typeorm';
import { PlanTemplateWeek } from './plan-template-week.entity';

@Entity('plan_template_day')
export class PlanTemplateDay {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  title: string;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column({ type: 'int' })
  dayOfWeek: number; // 1 = Monday, 7 = Sunday

  @Column({ type: 'int', nullable: true })
  duration?: number; // u minutima

  @Column({ type: 'int', nullable: true })
  tss?: number;

  @Column({ type: 'int', nullable: true })
  rpe?: number;

  @ManyToOne(() => PlanTemplateWeek, (week) => week.days, {
    onDelete: 'CASCADE',
  })
  week: PlanTemplateWeek;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @DeleteDateColumn({ nullable: true })
  deletedAt?: Date;
}
