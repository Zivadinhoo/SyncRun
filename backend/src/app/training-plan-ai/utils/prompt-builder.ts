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
  if (distanceInKm === 42) {
    return `
- Long runs must gradually build to at least 30–32 ${uom}
- Final long run in week ${durationInWeeks - 1} should be 28–30 ${uom}
- Include a 2–3 week taper phase before race day
- Weekly volume must reflect realistic marathon prep
- Training should build up total mileage gradually`;
  } else if (distanceInKm === 21) {
    return `
- Long runs must gradually increase to at least 18–20 ${uom}
- Include one tempo and one long run per week
- Final week must taper the load`;
  } else if (distanceInKm === 10) {
    return `
- Use interval sessions (400–1,000m), tempo runs, and strides
- Long runs should reach 10–12 ${uom}
- At least one rest or recovery day per week`;
  } else if (distanceInKm === 5) {
    return `
- Focus on short intervals (200–800m), strides, and light tempo runs
- Long run can be 6–8 ${uom}
- 2 rest days per week are acceptable`;
  }
  return '';
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

  const additionalRequirements = getDistanceSpecificRules(
    distanceInKm,
    durationInWeeks,
    uom,
  );

  const prompt = `
You are a professional running coach.

Generate a detailed ${durationInWeeks}-week training plan for an ${experience.toLowerCase()} runner who is preparing for a ${targetDistance} race (${distanceInKm} ${uom}) and aiming to finish in approximately ${targetTime}.

---

🏃‍♂️ Runner Profile:
- Experience: ${experience}
- Days per week available: ${daysPerWeek}
- Preferred training days: ${preferredDaysList}
- Start date: ${startDate}
- Goal type: ${goalTag}
- Goal text: ${goalText}
- Units: ${uom}

---

📋 Plan Requirements:
- Plan must have **exactly ${durationInWeeks} weeks**
- No more than ${daysPerWeek} training days per week
- Use only preferred days for training if possible
- Include variety: easy runs, tempo runs, long runs, intervals, rest
- Avoid sudden jumps in mileage
- Each day must include: "day", "type", "distance", optionally "pace"
${additionalRequirements}

---

🧾 Output Instructions:
- Return only **valid JSON**, no markdown, no commentary, no formatting
- JSON must follow this format:
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
