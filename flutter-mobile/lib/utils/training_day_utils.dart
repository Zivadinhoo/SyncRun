// import 'package:frontend/features/models/training_day.dart';
// import 'package:frontend/features/onboarding/models/ai_plan.dart';

// Map<int, List<TrainingDay>> groupTrainingDaysByWeek(
//   List<TrainingDay> days,
// ) {
//   days.sort((a, b) => a.date.compareTo(b.day));
//   final DateTime startDate = days.first.day as DateTime;
//   final Map<int, List<TrainingDay>> grouped = {};

//   for (final day in days) {
//     final int weekNumber =
//         ((day.day.difference(startDate).inDays) ~/ 7);
//     grouped.putIfAbsent(weekNumber, () => []);
//     grouped[weekNumber]!.add(day);
//   }
//   return grouped;
// }

// extension on String {
//   difference(DateTime startDate) {}
// }
