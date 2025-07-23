export function isValidAiPlan(
  plan: any,
  maxDaysPerWeek: number,
  durationInWeeks?: number,
): boolean {
  const weeks = plan?.metadata?.weeks;
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

  for (const week of weeks) {
    if (!week.days || !Array.isArray(week.days)) {
      console.warn(`❌ Week ${week.week} is missing days array.`);
      return false;
    }

    if (week.days.length > maxDaysPerWeek) {
      console.warn(`❌ Week ${week.week} has too many training days.`);
      return false;
    }

    let hasLongRun = false;

    for (const day of week.days) {
      if (!day.day || !day.type) {
        console.warn(`❌ Missing day or type in a training day.`);
        return false;
      }

      if (day.distance === null || day.distance === undefined) {
        console.warn(`❌ Missing distance for ${day.day}.`);
        return false;
      }

      if (day.pace && !/^(\d+):(\d+)\smin\/km$/.test(day.pace)) {
        console.warn(`❌ Invalid pace format: ${day.pace}`);
        return false;
      }

      if (
        typeof day.type === 'string' &&
        day.type.toLowerCase().includes('long')
      ) {
        if (hasLongRun) {
          console.warn(`❌ Multiple long runs in one week.`);
          return false;
        }
        hasLongRun = true;
      }
    }

    if (!hasLongRun && week.days.length >= 3) {
      console.warn(`❌ No long run found in week ${week.week}.`);
      return false;
    }
  }

  return true;
}
