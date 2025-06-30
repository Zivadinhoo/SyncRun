import 'package:frontend/features/models/training_day_feedback.dart';

class TrainingDay {
  final int id;
  final DateTime date;
  final String title;
  final String description;
  final int duration;
  final double? tss;
  final bool isCompleted;
  final String status;
  final TrainingDayFeedback? feedback;

  TrainingDay({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.duration,
    this.tss,
    required this.isCompleted,
    required this.status,
    this.feedback,
  });

  factory TrainingDay.fromJson(Map<String, dynamic> json) {
    return TrainingDay(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      tss: json['tss']?.toDouble(),
      isCompleted: json['isCompleted'] ?? false,
      status: json['status'],
      feedback:
          json['feedback'] != null
              ? TrainingDayFeedback.fromJson(
                json['feedback'],
              )
              : null,
    );
  }
}
