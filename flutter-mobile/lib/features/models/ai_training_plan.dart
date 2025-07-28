import 'dart:convert';

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
    final rawMetadata = json['metadata'];

    // Check and decode metadata if needed
    if (rawMetadata is String) {
      print(
        "❗️ WARNING: metadata is a String! Decoding...",
      );
    } else if (rawMetadata is Map<String, dynamic>) {
      print("✅ Metadata is a proper map.");
      print(
        "✅ Metadata weeks count: ${rawMetadata['weeks']?.length}",
      );
    }

    final metadata =
        rawMetadata is String
            ? jsonDecode(rawMetadata)
            : rawMetadata ?? {};

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

    final plan = AiTrainingPlan(
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

    print(
      "📦 Final weeks parsed into AiTrainingPlan: ${plan.weeks.length}",
    );
    return plan;
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
  final String name; // 🆕 e.g. "Day 1", "Monday"
  final String day; // e.g. Monday
  final String type; // e.g. Easy Run
  final dynamic distance; // Can be number or string
  final String? pace;
  final String status;
  final String? description;
  final int? duration; // in minutes
  final DateTime? date;

  TrainingDay({
    required this.id,
    required this.name,
    required this.day,
    required this.type,
    required this.distance,
    this.pace,
    required this.status,
    this.description,
    this.duration,
    this.date,
  });

  factory TrainingDay.fromJson(Map<String, dynamic> json) {
    return TrainingDay(
      id: json['id'] ?? -1,
      name:
          json['name'] ??
          json['day'] ??
          'Day', // Fallback to day if name not available
      day: json['day'] ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
      distance: json['distance'] ?? 0,
      pace: json['pace'],
      status: json['status'] ?? 'pending',
      description: json['description'],
      duration: json['duration'] as int?,
      date:
          json['date'] != null
              ? DateTime.tryParse(json['date'])
              : null,
    );
  }
}
