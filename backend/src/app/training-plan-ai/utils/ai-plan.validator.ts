export function isValidAiPlan(
  plan: any,
  maxDaysPerWeek: number,
  durationInWeeks?: number,
): boolean {
  if (plan?.error) {
    console.warn(`❌ Plan contains error message from AI: ${plan.error}`);
    return false;
  }

  const weeks = plan?.weeks || plan?.metadata?.weeks;
  const target = plan?.goalRaceDistance?.toLowerCase() ?? '';

  if (!weeks || !Array.isArray(weeks) || weeks.length === 0) {
    console.warn('❌ Invalid or empty weeks array.');
    return false;
  }

  if (durationInWeeks && weeks.length !== durationInWeeks) {
    console.warn(
      `❌ Plan duration mismatch. Expected ${durationInWeeks} weeks, got ${weeks.length}.`,
    );
    return false;
  }

  const expectedDays = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  const minPeakLongRunByRace: Record<string, number> = {
    '5k': 6,
    '10k': 10,
    '21k': 17,
    'half marathon': 17,
    '42k': 28,
    marathon: 28,
  };

  const maxPeakLongRunByRace: Record<string, number> = {
    '5k': 8,
    '10k': 13,
    '21k': 20,
    'half marathon': 20,
    '42k': 32,
    marathon: 32,
  };

  const minPeakLongRun = minPeakLongRunByRace[target] ?? 6;
  const maxPeakLongRun = maxPeakLongRunByRace[target] ?? 30;

  const standardPace = /^(\d+):(\d+)\smin\/km$/i;
  const intervalPattern =
    /^\d+x\d+m at \d{1,2}:\d{2} min\/km with \d+m recovery$/i;
  const descriptivePattern = /^[A-Za-z0-9\s\-:,@\/\.\(\)]+$/i;

  let foundValidPeak = false;

  for (let i = 0; i < weeks.length; i++) {
    const week = weeks[i];

    if (!week.days || !Array.isArray(week.days)) {
      console.warn(`❌ Week ${week.week} is missing days array.`);
      return false;
    }

    const actualDays = week.days.map((d) => d.day?.toLowerCase());
    const missingDays = expectedDays.filter((day) => !actualDays.includes(day));
    if (missingDays.length > 0) {
      console.warn(
        `❌ Week ${week.week} is missing these days: ${missingDays.join(', ')}`,
      );
      return false;
    }

    let trainingCount = 0;
    let runTrainingCount = 0;
    let restCount = 0;
    let hasLongRun = false;

    for (const day of week.days) {
      if (!day.day || !day.type) {
        console.warn(`❌ Missing day or type in a training day.`);
        return false;
      }

      const type = day.type.toLowerCase();
      const dayName = day.day.toLowerCase();

      const isRecovery = ['rest', 'stretch', 'mobility'].includes(type);
      const isRun = [
        'run',
        'tempo',
        'interval',
        'easy',
        'long',
        'fartlek',
        'progression',
      ].some((word) => type.includes(word));
      const isRaceDay = type.includes('race');

      if (!isRecovery && !isRaceDay) {
        if (
          day.distance === null ||
          day.distance === undefined ||
          typeof day.distance !== 'number' ||
          day.distance <= 0
        ) {
          console.warn(`❌ Invalid or missing distance for ${day.day}.`);
          return false;
        }
      }

      if (
        day.pace &&
        !(
          standardPace.test(day.pace) ||
          intervalPattern.test(day.pace) ||
          descriptivePattern.test(day.pace)
        )
      ) {
        console.warn(`❌ Invalid pace format: ${day.pace}`);
        return false;
      }

      if (!isRecovery && !isRaceDay) trainingCount++;
      if (isRun) runTrainingCount++;
      if (type === 'rest') restCount++;

      if (type.includes('long')) {
        if (hasLongRun) {
          console.warn(`❌ Multiple long runs in week ${week.week}.`);
          return false;
        }

        if (day.distance > maxPeakLongRun) {
          console.warn(
            `❌ Long run too long for ${target} plan: ${day.distance} km (max allowed: ${maxPeakLongRun})`,
          );
          return false;
        }

        const isPeakWeek = i >= weeks.length - 3;
        if (isPeakWeek && day.distance >= minPeakLongRun) {
          foundValidPeak = true;
        }

        hasLongRun = true;
      }
    }

    // Validation based on business rules:
    if (trainingCount < 2) {
      console.warn(`❌ Week ${week.week} has less than 2 training sessions.`);
      return false;
    }

    if (trainingCount > 6) {
      console.warn(`❌ Week ${week.week} has more than 6 training sessions.`);
      return false;
    }

    if (restCount === 0) {
      console.warn(`❌ Week ${week.week} must include at least one rest day.`);
      return false;
    }

    if (runTrainingCount < 2) {
      console.warn(
        `❌ Week ${week.week} must have at least 2 run-type trainings.`,
      );
      return false;
    }

    const isTaperWeek = i >= weeks.length - 2;
    if (!isTaperWeek && trainingCount >= 3 && !hasLongRun) {
      console.warn(`❌ No long run found in week ${week.week}.`);
      return false;
    }
  }

  if (!foundValidPeak) {
    console.warn('❌ No valid peak long run found in final weeks.');
    return false;
  }

  return true;
}
