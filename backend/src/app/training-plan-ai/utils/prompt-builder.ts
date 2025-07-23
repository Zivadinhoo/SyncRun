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
    durationInWeeks = 8, // fallback za starije DTO-e bez ovog polja
  } = dto;

  const uom = (units ?? 'km').toUpperCase();
  const buffer: string[] = [];

  // 🧠 Role
  buffer.push('You are a professional running coach.');
  buffer.push(
    'Generate a structured running plan using the profile and rules below.',
  );

  // 🏃 Runner Profile
  buffer.push('\n### Runner Profile');
  buffer.push(`- Goal: ${goalText}`);
  buffer.push(`- Goal type: ${goalTag}`);
  buffer.push(`- Target distance: ${targetDistance}`);
  buffer.push(`- Target time: ${targetTime}`);
  buffer.push(`- Experience level: ${experience}`);
  buffer.push(`- Days per week: ${daysPerWeek}`);
  buffer.push(`- Preferred training days: ${preferredDays.join(', ')}`);
  buffer.push(`- Start date: ${startDate}`);
  buffer.push(`- Units: ${uom}`);

  // 📋 Requirements
  buffer.push('\n### Plan Requirements');
  buffer.push(`- Duration: ${durationInWeeks} weeks`);
  buffer.push(`- Max ${daysPerWeek} sessions per week`);
  buffer.push(`- Match preferred days when possible`);
  buffer.push(
    '- Include variety: intervals, tempo runs, long runs, easy runs, and rest',
  );
  buffer.push('- Build gradually over time, no sudden jumps');
  buffer.push('- Avoid exact duplicates in the same week');
  buffer.push(
    '- Make sure long run appears in most weeks, ideally on weekends',
  );
  buffer.push('- Distance must be realistic and aligned with experience');
  buffer.push(
    '- Each day should have: day name, type, distance, optional pace',
  );

  // 🧱 Output Format
  buffer.push('\n### Output format:');
  buffer.push(`{
  "name": "AI ${targetDistance} Plan",
  "description": "${durationInWeeks}-week ${experience.toLowerCase()} ${targetDistance} training plan for ${goalText}",
  "durationInWeeks": ${durationInWeeks},
  "goalRaceDistance": "${targetDistance}",
  "generatedByModel": "gpt-4o",
  "metadata": {
    "weeks": [
      {
        "week": 1,
        "days": [
          { "day": "Tuesday", "type": "Easy Run", "distance": 5, "pace": "6:00 min/${uom}" },
          { "day": "Thursday", "type": "Tempo Run", "distance": 6, "pace": "5:30 min/${uom}" },
          { "day": "Sunday", "type": "Long Run", "distance": 10, "pace": "6:20 min/${uom}" }
        ]
      }
    ]
  }
}`);

  // 📢 Final instruction
  buffer.push('\n✅ Respond ONLY with valid JSON. No text or explanations.');

  return buffer.join('\n');
}
