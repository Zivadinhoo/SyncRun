import 'training_day_model.dart';

class TrainingWeekModel {
  final int week;
  final List<TrainingDayModel> days;

  TrainingWeekModel({
    required this.week,
    required this.days,
  });

  factory TrainingWeekModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TrainingWeekModel(
      week: json['week'],
      days:
          (json['days'] as List<dynamic>)
              .map((d) => TrainingDayModel.fromJson(d))
              .toList(),
    );
  }
}
