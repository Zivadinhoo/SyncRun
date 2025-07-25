import { OnboardingAnswersDto } from '../dto/onboarding-answers.dto';

function resolveTargetDistanceInKm(distance: string): number {
  const lower = distance.toLowerCase();

  if (lower === '5k' || lower === '5') return 5;
  if (lower === '10k' || lower === '10') return 10;
  if (lower === '21k' || lower === 'half marathon' || lower === '21') return 21;
  if (lower === '42k' || lower === 'marathon' || lower === '42') return 42;

  throw new Error(`Unsupported targetDistance: ${distance}`);
}

function getDistanceSpecificRules(
  distanceInKm: number,
  durationInWeeks: number,
  uom: string,
): string {
  switch (distanceInKm) {
    case 42:
      return `
- Long runs should gradually build from 12–16 ${uom} to a peak of ~30–32 ${uom} around 3–4 weeks before race day
- Include a 2–3 week taper phase before the race
- Never schedule more than one long run per week
- Avoid sudden weekly volume spikes (>10%)
- Mix in weekly easy runs, tempo efforts, intervals, strides, and full rest days`;
    case 21:
      return `
- Long runs should progress from ~10–12 ${uom} to a peak of ~18–20 ${uom} 2–3 weeks before race day
- Include at least one tempo session and one long run per week
- Final week should reduce overall volume by 30–40% for tapering`;
    case 10:
      return `
- Alternate interval sessions (e.g. 400–1000m repeats) with tempo runs and strides
- Long runs should build up to 10–12 ${uom}, once weekly
- Always include at least one full recovery or rest day per week`;
    case 5:
      return `
- Prioritize short intervals (200–800m), strides, and light tempos
- Long runs can reach 6–8 ${uom} at most, done once per week
- 2 rest days per week are acceptable for recovery`;
    default:
      return '';
  }
}

export function buildPromptFromDto(dto: OnboardingAnswersDto): string {
  const {
    goalText,
    goalTag,
    targetDistance,
    targetTime,
    experience,
    daysPerWeek,
    preferredDays,
    startDate,
    units,
    durationInWeeks,
  } = dto;

  if (!durationInWeeks) {
    throw new Error(
      '❌ durationInWeeks is required to generate a training plan.',
    );
  }

  const uom = (units ?? 'km').toUpperCase();
  const preferredDaysList = preferredDays.join(', ');
  const distanceInKm = resolveTargetDistanceInKm(targetDistance);
  const distanceRules = getDistanceSpecificRules(
    distanceInKm,
    durationInWeeks,
    uom,
  );

  const prompt = `
You are a professional endurance running coach with experience training athletes for ${targetDistance} races.

Generate a realistic and safe ${durationInWeeks}-week training plan for an ${experience.toLowerCase()} runner who is training for a ${targetDistance} (${distanceInKm} ${uom}) and wants to finish in approximately ${targetTime}.

---

🏃‍♂️ Runner Profile:
- Experience: ${experience}
- Weekly availability: ${daysPerWeek} sessions max
- Preferred training days: ${preferredDaysList}
- Start date: ${startDate}
- Goal: ${goalText} (${goalTag})
- Distance units: ${uom}

---

📋 Coaching Guidelines:
- Plan must be **${durationInWeeks} full weeks**
- Use only the runner’s preferred days for training
- Do **not exceed ${daysPerWeek} training days per week**
- Long runs must progress gradually and peak ~2–4 weeks before race day
- Taper period: reduce volume in the final 1–3 weeks depending on race distance
- Do not schedule hard sessions back-to-back
- Weekly variety: easy runs, tempo runs, long runs, intervals, recovery days
- Avoid unrealistic volume spikes (>10% jump from previous week)
${distanceRules}

---

🧾 Output Format:
- Return only **strict JSON** (no markdown, no explanations)
- JSON should follow this format:

{
  "name": "AI ${targetDistance} Plan",
  "description": "${durationInWeeks}-week ${experience.toLowerCase()} ${targetDistance} training plan to complete in ${targetTime}",
  "durationInWeeks": ${durationInWeeks},
  "goalRaceDistance": "${targetDistance}",
  "generatedByModel": "gpt-4o",
  "metadata": {
    "weeks": [
      {
        "week": 1,
        "days": [
          {
            "day": "Monday",
            "type": "Easy Run",
            "distance": 5,
            "pace": "6:00 min/${uom}"
          }
        ]
      }
    ]
  }
}
`;

  return prompt.trim();
}
