import 'package:frontend/features/models/training_day.dart';

Map<int, List<TrainingDay>> groupTrainingDaysByWeek(
  List<TrainingDay> days,
) {
  days.sort((a, b) => a.date.compareTo(b.date));
  final DateTime startDate = days.first.date;
  final Map<int, List<TrainingDay>> grouped = {};

  for (final day in days) {
    final int weekNumber =
        ((day.date.difference(startDate).inDays) ~/ 7);
    grouped.putIfAbsent(weekNumber, () => []);
    grouped[weekNumber]!.add(day);
  }
  return grouped;
}
