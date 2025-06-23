import 'dotenv/config';
import { PlanTemplate } from '../entities/plan-template.entity';
import { PlanTemplateWeek } from '../entities/plan-template-week.entity';
import { PlanTemplateDay } from '../entities/plan-template-day.entity';
import { AppDataSource } from '../data-source';

async function seed() {
  // ✅ Prvo inicijalizuj konekciju
  await AppDataSource.initialize();

  const templateRepo = AppDataSource.getRepository(PlanTemplate);
  const weekRepo = AppDataSource.getRepository(PlanTemplateWeek);
  const dayRepo = AppDataSource.getRepository(PlanTemplateDay);

  const template = templateRepo.create({
    name: '5K Beginner Plan',
    description:
      '4-week plan for beginner runners aiming to complete a 5K race.',
    durationInWeeks: 4,
  });

  await templateRepo.save(template);

  for (let w = 1; w <= 4; w++) {
    const week = weekRepo.create({
      template,
      weekNumber: w,
    });

    await weekRepo.save(week);

    const days = [
      {
        dayOfWeek: 1,
        title: 'Easy Run',
        description: '20 min easy jog',
        duration: 20,
      },
      {
        dayOfWeek: 3,
        title: 'Intervals',
        description: '4 x 400m fast with 200m walk',
        duration: 25,
      },
      {
        dayOfWeek: 5,
        title: 'Long Run',
        description: '4 km at slow pace',
        duration: 35,
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

  console.log('✅ Seeded 5K plan template');

  // ✅ Uništi konekciju kad završiš
  await AppDataSource.destroy();
}

// Pokreni seed funkciju
seed().catch((e) => {
  console.error('❌ Error while seeding:', e);
  AppDataSource.destroy();
});
