class AiTrainingPlan {
  final int id;
  final String name;
  final String description;
  final String? goalRaceDistance;
  final String? generatedByModel;
  final int durationInWeeks;
  final List<TrainingWeek> weeks;

  AiTrainingPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.goalRaceDistance,
    required this.generatedByModel,
    required this.durationInWeeks,
    required this.weeks,
  });

  factory AiTrainingPlan.fromJson(
    Map<String, dynamic> json,
  ) {
    final metadata = json['metadata'] ?? {};

    // Fallback for weeks in case they're in the root or metadata
    final weeksJson =
        metadata['weeks'] ?? json['weeks'] ?? [];

    final weeks =
        (weeksJson as List<dynamic>)
            .map(
              (w) => TrainingWeek.fromJson(
                w as Map<String, dynamic>,
              ),
            )
            .toList();

    return AiTrainingPlan(
      id: json['id'] ?? -1,
      name:
          json['name'] ??
          metadata['name'] ??
          'Unnamed Plan',
      description:
          json['description'] ??
          metadata['description'] ??
          '',
      goalRaceDistance:
          json['goalRaceDistance'] ??
          metadata['goalRaceDistance'],
      generatedByModel:
          json['generatedByModel'] ??
          metadata['generatedByModel'],
      durationInWeeks:
          json['durationInWeeks'] ??
          metadata['durationInWeeks'] ??
          weeks.length,
      weeks: weeks,
    );
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
  final dynamic distance;
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
