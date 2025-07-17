class AiTrainingPlan {
  final List<TrainingWeek> weeks;

  AiTrainingPlan({required this.weeks});

  factory AiTrainingPlan.fromJson(
    Map<String, dynamic> json,
  ) {
    final weeksJson = json['weeks'] as List<dynamic>? ?? [];
    final weeks =
        weeksJson
            .map(
              (w) => TrainingWeek.fromJson(
                w as Map<String, dynamic>,
              ),
            )
            .toList();
    return AiTrainingPlan(weeks: weeks);
  }
}

class TrainingWeek {
  final int week;
  final List<TrainingDay> days;

  TrainingWeek({required this.week, required this.days});

  factory TrainingWeek.fromJson(Map<String, dynamic> json) {
    final daysJson = json['days'] as List<dynamic>? ?? [];
    final days =
        daysJson
            .map(
              (d) => TrainingDay.fromJson(
                d as Map<String, dynamic>,
              ),
            )
            .toList();
    return TrainingWeek(
      week: json['week'] ?? 0,
      days: days,
    );
  }
}

class TrainingDay {
  final int id;
  final String day;
  final String type;
  final dynamic distance; // može biti broj ili string
  final String? pace;
  final String status;

  TrainingDay({
    required this.id,
    required this.day,
    required this.type,
    required this.distance,
    this.pace,
    required this.status,
  });

  factory TrainingDay.fromJson(Map<String, dynamic> json) {
    return TrainingDay(
      id: json['id'] ?? -1,
      day: json['day'] ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
      distance: json['distance'] ?? 0,
      pace: json['pace'],
      status: json['status'] ?? 'pending',
    );
  }
}
