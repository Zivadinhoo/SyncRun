import 'training_plan.dart';

class AssignedPlan {
  final int id;
  final bool isCompleted;
  final DateTime assignedAt;
  final TrainingPlan trainingPlan;

  AssignedPlan({
    required this.id,
    required this.isCompleted,
    required this.assignedAt,
    required this.trainingPlan,
  });

  factory AssignedPlan.fromJson(Map<String, dynamic> json) {
    {
      return AssignedPlan(
        id: json['id'],
        isCompleted: json['isCompleted'] ?? false,
        assignedAt: DateTime.parse(json['assignedAt']),
        trainingPlan: TrainingPlan.fromJson(
          json['trainingPlan'],
        ),
      );
    }
  }
}
