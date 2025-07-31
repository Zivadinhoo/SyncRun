import 'package:frontend/features/models/training_day.dart';

class TrainingWeek {
  final int week;
  final List<TrainingDay> days;

  TrainingWeek({required this.week, required this.days});

  factory TrainingWeek.fromJson(Map<String, dynamic> json) {
    return TrainingWeek(
      week: json['week'] ?? 0,
      days:
          (json['days'] as List<dynamic>? ?? [])
              .map((d) => TrainingDay.fromJson(d))
              .toList(),
    );
  }
}
