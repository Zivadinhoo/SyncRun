import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { PlanTemplate } from './plan-template.entity';

@Entity()
export class PlanTemplateWeek {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => PlanTemplate, (template) => template.weeks, {
    onDelete: 'CASCADE',
  })
  template: PlanTemplate;

  @Column()
  weekNumber: number;

  @Column('jsonb')
  days: {
    day: string;
    sessionType: string; // "Easy", "Tempo", "Long Run"
    description: string;
    tss?: number;
  }[];
}
