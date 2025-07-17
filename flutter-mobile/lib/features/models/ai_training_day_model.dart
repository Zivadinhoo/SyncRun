class AiTrainingDay {
  final int id;
  final String day;
  final String type;
  final dynamic distance;
  final String? pace;
  final String? status;

  AiTrainingDay({
    required this.id,
    required this.day,
    required this.type,
    required this.distance,
    this.pace,
    this.status,
  });

  factory AiTrainingDay.fromJson(
    Map<String, dynamic> json,
  ) {
    return AiTrainingDay(
      id: json['id'],
      day: json['day'],
      type: json['type'],
      distance: json['distance'],
      pace: json['pace'],
      status: json['status'],
    );
  }
}
