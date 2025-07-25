export function isValidAiPlan(
  plan: any,
  maxDaysPerWeek: number,
  durationInWeeks?: number,
): boolean {
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

  // Expected peak long run by race type (only enforced in last 3–4 weeks)
  const peakLongRunByRace: Record<string, number> = {
    '5k': 6,
    '10k': 10,
    '21k': 17,
    'half marathon': 17,
    '42k': 28,
    marathon: 28,
  };
  const minPeakLongRun = peakLongRunByRace[target] ?? 6;

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

      if (
        day.distance === null ||
        day.distance === undefined ||
        typeof day.distance !== 'number' ||
        day.distance <= 0
      ) {
        console.warn(`❌ Invalid or missing distance for ${day.day}.`);
        return false;
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

      // Long run detection
      const isLongRun =
        typeof day.type === 'string' && day.type.toLowerCase().includes('long');

      if (isLongRun) {
        if (hasLongRun) {
          console.warn(`❌ Multiple long runs in week ${week.week}.`);
          return false;
        }

        // ✅ Enforce peak distance only in last 2–3 weeks (not week 1+)
        const isPeakWeek = i >= weeks.length - 3;
        if (isPeakWeek && day.distance >= minPeakLongRun) {
          foundValidPeak = true;
        }

        hasLongRun = true;
      }
    }

    // All build weeks (not taper) with 3+ days should have *a* long run
    const isTaperWeek = i >= weeks.length - 2;
    if (!isTaperWeek && week.days.length >= 3 && !hasLongRun) {
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
