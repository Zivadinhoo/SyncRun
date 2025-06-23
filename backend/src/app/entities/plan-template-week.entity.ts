import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
} from 'typeorm';
import { PlanTemplate } from './plan-template.entity';
import { PlanTemplateDay } from './plan-template-day.entity';

@Entity()
export class PlanTemplateWeek {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => PlanTemplate, (template) => template.weeks, {
    onDelete: 'CASCADE',
  })
  template: PlanTemplate;

  @OneToMany(() => PlanTemplateDay, (day) => day.week, { cascade: true })
  days: PlanTemplateDay[];

  @Column()
  weekNumber: number;
}
