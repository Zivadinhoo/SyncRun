import { OnboardingAnswersDto } from '../dto/onboarding-answers.dto';

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
  } = dto;

  const buffer: string[] = [];

  buffer.push('You are a professional running coach.');
  buffer.push('');
  buffer.push('### Runner Profile');
  buffer.push(`- Goal: ${goalText}`);
  buffer.push(`- Goal type: ${goalTag}`);
  buffer.push(`- Target distance: ${targetDistance}`);
  buffer.push(`- Target time: ${targetTime}`);
  buffer.push(`- Experience level: ${experience}`);
  buffer.push(`- Available days per week: ${daysPerWeek}`);
  buffer.push(`- Preferred training days: ${preferredDays.join(', ')}`);
  buffer.push(`- Start date: ${startDate}`);
  buffer.push(`- Units: ${(units ?? 'km').toUpperCase()}`);

  buffer.push('');
  buffer.push('### Plan Requirements');
  buffer.push(`- The plan should be 8 weeks long.`);
  buffer.push(`- Do NOT assign more than ${daysPerWeek} sessions per week.`);
  buffer.push(
    '- Prioritize quality workouts: intervals, tempo runs, long runs.',
  );
  buffer.push('- Include rest and flexibility around preferred days.');
  buffer.push('- Add progression: build volume gradually over weeks.');
  buffer.push('- Mention type, distance, and pace.');
  buffer.push('- Format the output as valid JSON.');

  buffer.push('');
  buffer.push('### Output format:');
  buffer.push(`{
  "weeks": [
    {
      "week": 1,
      "days": [
        { "day": "Monday", "type": "Easy Run", "distance": 5, "pace": "6:00 min/km" },
        { "day": "Tuesday", "type": "Rest" }
      ]
    }
  ]
}`);
  buffer.push('');
  buffer.push('✅ Return ONLY valid JSON. No explanations.');

  return buffer.join('\n');
}
