import { DataSource } from 'typeorm';
import { User } from './entities/user.entity';
import { AssignedPlan } from './entities/assigned-plan.entity';
import { TrainingPlan } from './entities/training-plan.entity';
import { TrainingDay } from './entities/training-day.entity';
import { PlanTemplate } from './entities/plan-template.entity';
import { PlanTemplateWeek } from './entities/plan-template-week.entity';
import { PlanTemplateDay } from './entities/plan-template-day.entity';
import { TrainingDayFeedback } from './entities/training-day-feedback.entity';

export const AppDataSource = new DataSource({
  type: 'postgres',
  url: process.env.DATABASE_URL,
  synchronize: true,
  logging: true,
  entities: [
    User,
    TrainingPlan,
    TrainingDay,
    AssignedPlan,
    TrainingDayFeedback,
    PlanTemplate,
    PlanTemplateWeek,
    PlanTemplateDay,
  ],
  migrations: ['dist/migrations/*.js'],
});
