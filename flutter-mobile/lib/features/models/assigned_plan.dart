import 'training_plan.dart';
import 'training_day.dart';

class AssignedPlan {
  final int id;
  final bool isCompleted;
  final DateTime assignedAt;
  final TrainingPlan trainingPlan;
  final int? trainingDayId;
  final double? tss;
  final int? rpe;
  final List<TrainingDay> trainingDays;

  AssignedPlan({
    required this.id,
    required this.isCompleted,
    required this.assignedAt,
    required this.trainingPlan,
    required this.trainingDayId,
    this.tss,
    this.rpe,
    required this.trainingDays,
  });

  factory AssignedPlan.fromJson(Map<String, dynamic> json) {
    final trainingPlanJson = json['trainingPlan'];
    final trainingDayId = json['trainingDayId'];

    if (trainingPlanJson == null) {
      throw Exception(
        "❌ Error: 'trainingPlan' is missing in AssignedPlan JSON response. Full JSON: $json",
      );
    }

    final List<TrainingDay> parsedDays =
        (json['trainingDays'] as List<dynamic>?)
            ?.map((e) => TrainingDay.fromJson(e))
            .toList() ??
        [];

    return AssignedPlan(
      id: json['id'],
      isCompleted: json['isCompleted'] ?? false,
      assignedAt: DateTime.parse(json['assignedAt']),
      trainingPlan: TrainingPlan.fromJson(trainingPlanJson),
      trainingDayId: trainingDayId,
      tss: (json['tss'] as num?)?.toDouble(),
      rpe: json['rpe'] as int?,
      trainingDays: parsedDays,
    );
  }
}
