import 'package:frontend/features/models/training_week.dart';
import 'package:frontend/features/models/training_day.dart';

TrainingWeek normalizeWeekWithAllDays(TrainingWeek week) {
  const allDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final existingDays = week.days.map((d) => d.day).toSet();
  final missingDays = allDays.where(
    (d) => !existingDays.contains(d),
  );

  final filledDays = [...week.days];

  for (final dayName in missingDays) {
    filledDays.add(
      TrainingDay(
        id: -1, // dummy ID
        day: dayName,
        type: 'Rest',
        distance: 0,
        pace: null,
        status: 'pending',
        date: null,
      ),
    );
  }

  // Sort by correct day order
  filledDays.sort(
    (a, b) =>
        allDays.indexOf(a.day) - allDays.indexOf(b.day),
  );

  return TrainingWeek(week: week.week, days: filledDays);
}
