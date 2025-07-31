import { OnboardingAnswersDto } from '../dto/onboarding-answers.dto';
import { getDistanceSpecificRules } from './distance-specific-rules';
import { resolveTargetDistanceInKm } from './resolve-target-distance';

export function buildPromptWithRecoveryFromDto(
  dto: OnboardingAnswersDto,
): string {
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

  return `
You are a world-class endurance running coach with deep knowledge of physiology, training periodization, injury prevention, and performance optimization.

Create a realistic, safe, and progressive ${durationInWeeks}-week training plan for an ${experience.toLowerCase()} runner preparing for a ${targetDistance} race (${distanceInKm} ${uom}). The runner wants to finish in approximately ${targetTime}.

---

Runner Profile:
- Experience: ${experience}
- Weekly availability: max ${daysPerWeek} sessions
- Preferred training days: ${preferredDaysList}
- Start date: ${startDate}
- Goal: ${goalText} (${goalTag})
- Units of measurement: ${uom}

---

COACHING GUIDELINES:
- Use only preferred training days for training sessions
- Do not exceed ${daysPerWeek} training sessions per week
- Each week must explicitly include all 7 days: Monday through Sunday
- Non-training days must still be present (e.g., as Rest, Stretch, or Mobility)
- Each week must include:
  - At least 2 training days
  - At most 6 training days
  - At least 1 full Rest day (type: "Rest")
  - At least 2 running-type sessions (e.g. Easy Run, Long Run, Tempo, Intervals, Fartlek)
- Only classify sessions as training sessions if they involve running or structured workouts (e.g. Easy Run, Long Run, Tempo, Intervals, Fartlek)
- Do not count Rest, Stretch, or Mobility as training sessions
- Include weekly variety: easy runs, tempo, intervals, long runs, recovery, and optional stretch/mobility
- Long runs must progress weekly and peak approximately 2–3 weeks before race day
- The long run should be the longest and most important session of the week
- Include at least one cutback week every 3–4 weeks to reduce fatigue
- Include a taper phase in the final 1–3 weeks
- Never place hard sessions back-to-back
- Avoid sudden volume spikes (>10% week-to-week increase)
- Prioritize quality over quantity
- Final week must include a Race Day (type: "Race") on the final preferred training day
- Ensure the plan respects basic recovery principles and allows for sustainable progress

${distanceRules}

---

Output Rules:
- Return only strict valid JSON
- Do not include markdown, comments, code blocks, or explanations
- The response must match this structure:
- You must return a complete training plan with exactly ${durationInWeeks} full weeks in the "weeks" array
- Do not include only the first week as an example – generate and return the full plan

{
  "name": "AI ${targetDistance} Plan",
  "description": "${durationInWeeks}-week ${experience.toLowerCase()} ${targetDistance} training plan targeting ${targetTime}",
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
          },
          {
            "day": "Tuesday",
            "type": "Rest"
          },
          {
            "day": "Wednesday",
            "type": "Intervals",
            "distance": 6,
            "pace": "4:30 min/${uom}"
          },
          {
            "day": "Thursday",
            "type": "Stretch"
          },
          {
            "day": "Friday",
            "type": "Easy Run",
            "distance": 5,
            "pace": "6:10 min/${uom}"
          },
          {
            "day": "Saturday",
            "type": "Rest"
          },
          {
            "day": "Sunday",
            "type": "Long Run",
            "distance": 12,
            "pace": "5:45 min/${uom}"
          }
        ]
      }
    ]
  }
}
`.trim();
}
