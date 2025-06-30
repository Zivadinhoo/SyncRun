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
    where: { name: 'Sub 2h Half Marathon - 8 Weeks' },
  });

  if (existing) {
    console.log('⚠️ Plan already exists. Skipping seed.');
    return;
  }

  const template = templateRepo.create({
    name: 'Sub 2h Half Marathon - 8 Weeks',
    description: '8-week plan for breaking 2h in a half marathon.',
    durationInWeeks: 8,
  });

  await templateRepo.save(template);

  for (let w = 1; w <= 8; w++) {
    const week = weekRepo.create({
      template,
      weekNumber: w,
    });

    await weekRepo.save(week);

    const days = [
      {
        dayOfWeek: 1,
        title: 'Rest Day',
        description: 'Complete rest.',
        duration: 0,
      },
      {
        dayOfWeek: 2,
        title: 'Tempo Run',
        description: `Tempo run - sustain moderately hard pace.`,
        duration: 45 + w * 2,
      },
      {
        dayOfWeek: 3,
        title: 'Recovery Jog',
        description: 'Easy jog to loosen legs.',
        duration: 30,
      },
      {
        dayOfWeek: 4,
        title: 'Intervals',
        description: '6x800m @ 5:00/km with recoveries.',
        duration: 50,
      },
      {
        dayOfWeek: 5,
        title: 'Rest Day',
        description: 'Optional stretching or walk.',
        duration: 0,
      },
      {
        dayOfWeek: 6,
        title: 'Easy Run',
        description: 'Run at conversational pace.',
        duration: 40,
      },
      {
        dayOfWeek: 7,
        title: 'Long Run',
        description: 'Gradual pace progression.',
        duration: 80 + w * 5,
      },
    ];

    for (const d of days) {
      const day = dayRepo.create({
        week,
        ...d,
      });

      await dayRepo.save(day);
    }
  }

  console.log('✅ Seeded Sub 2h Half Marathon plan');
  await AppDataSource.destroy();
}

seed().catch((e) => {
  console.error('❌ Error while seeding:', e);
  AppDataSource.destroy();
});
