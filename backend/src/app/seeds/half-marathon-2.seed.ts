import 'dotenv/config';
import { AppDataSource } from '../data-source';
import { PlanTemplate } from '../entities/plan-template.entity';
import { PlanTemplateWeek } from '../entities/plan-template-week.entity';
import { PlanTemplateDay } from '../entities/plan-template-day.entity';

export async function seed() {
  await AppDataSource.initialize();

  const templateRepo = AppDataSource.getRepository(PlanTemplate);
  const weekRepo = AppDataSource.getRepository(PlanTemplateWeek);
  const dayRepo = AppDataSource.getRepository(PlanTemplateDay);

  const existing = await templateRepo.findOne({
    where: { name: 'Half Marathon - No Rest Days (8 Weeks)' },
  });

  if (existing) {
    console.log('⚠️ Plan already exists. Skipping seed.');
    return;
  }

  const template = templateRepo.create({
    name: 'Half Marathon - No Rest Days (8 Weeks)',
    description: 'Every day has a structured workout, no rest days included.',
    durationInWeeks: 8,
  });

  await templateRepo.save(template);

  const trainingTypes = [
    {
      title: 'Tempo Run',
      description: 'Run at a sustained, comfortably hard pace.',
      baseDuration: 40,
    },
    {
      title: 'Easy Run',
      description: 'Run at a relaxed, conversational pace.',
      baseDuration: 35,
    },
    {
      title: 'Intervals',
      description: '6x800m at 5K pace with equal recovery jogs.',
      baseDuration: 45,
    },
    {
      title: 'Progression Run',
      description: 'Start easy and finish fast.',
      baseDuration: 50,
    },
    {
      title: 'Recovery Jog',
      description: 'Very easy pace, shake out legs.',
      baseDuration: 30,
    },
    {
      title: 'Hill Repeats',
      description: '8x hill sprints with jog down.',
      baseDuration: 40,
    },
    {
      title: 'Long Run',
      description: 'Steady endurance run at comfortable pace.',
      baseDuration: 70,
    },
  ];

  for (let w = 1; w <= 8; w++) {
    const week = weekRepo.create({
      template,
      weekNumber: w,
    });

    await weekRepo.save(week);

    for (let d = 0; d < 7; d++) {
      const workout = trainingTypes[d % trainingTypes.length];

      const day = dayRepo.create({
        week,
        dayOfWeek: d + 1,
        title: workout.title,
        description: workout.description,
        duration: workout.baseDuration + w * 2, // scale over weeks
      });

      await dayRepo.save(day);
    }
  }

  console.log('✅ Seeded Half Marathon No Rest Plan');
  await AppDataSource.destroy();
}

seed().catch((e) => {
  console.error('❌ Error while seeding:', e);
  AppDataSource.destroy();
});
