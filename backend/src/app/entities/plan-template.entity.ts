import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { PlanTemplateWeek } from './plan-template-week.entity';

@Entity()
export class PlanTemplate {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column()
  durationInWeeks: number;

  @Column({ type: 'text' })
  description: string;

  @OneToMany(() => PlanTemplateWeek, (week) => week.template, {
    cascade: true,
  })
  weeks: PlanTemplateWeek[];
}
