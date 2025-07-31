import 'dart:convert';

import 'package:frontend/features/models/training_week.dart';

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
    final dynamic meta = json['metadata'];
    final Map<String, dynamic> metadata =
        meta is String
            ? jsonDecode(meta)
            : meta is Map<String, dynamic>
            ? meta
            : {};

    final weeksJson =
        metadata['weeks'] ?? json['weeks'] ?? [];

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
          weeksJson.length,
      weeks:
          (weeksJson as List)
              .map((w) => TrainingWeek.fromJson(w))
              .toList(),
    );
  }
}
