class AiTrainingPlan {
  final List<TrainingWeek> weeks;

  AiTrainingPlan({required this.weeks});

  factory AiTrainingPlan.fromJson(
    Map<String, dynamic> json,
  ) {
    final weeksJson = json['weeks'] as List<dynamic>;
    final weeks =
        weeksJson
            .map((w) => TrainingWeek.fromJson(w))
            .toList();
    return AiTrainingPlan(weeks: weeks);
  }
}

class TrainingWeek {
  final int week;
  final List<TrainingDay> days;

  TrainingWeek({required this.week, required this.days});

  factory TrainingWeek.fromJson(Map<String, dynamic> json) {
    final daysJson = json['days'] as List<dynamic>;
    final days =
        daysJson
            .map((d) => TrainingDay.fromJson(d))
            .toList();
    return TrainingWeek(week: json['week'], days: days);
  }
}

class TrainingDay {
  final String day;
  final String type;
  final dynamic
  distance; // Može biti int ili string (npr. "8x200m")

  TrainingDay({
    required this.day,
    required this.type,
    required this.distance,
  });

  factory TrainingDay.fromJson(Map<String, dynamic> json) {
    return TrainingDay(
      day: json['day'],
      type: json['type'],
      distance: json['distance'],
    );
  }
}
