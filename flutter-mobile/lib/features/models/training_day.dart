class TrainingDay {
  final int? id;
  final String day;
  final String type;
  final double distance;
  final String? pace;
  final String status;
  final String? description;
  final DateTime? date;

  TrainingDay({
    required this.day,
    required this.type,
    required this.distance,
    required this.pace,
    required this.status,
    this.description,
    this.date,
    this.id,
  });

  factory TrainingDay.fromJson(Map<String, dynamic> json) {
    return TrainingDay(
      id: json['id'],
      day: json['day'] ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
      distance:
          (json['distance'] as num?)?.toDouble() ?? 0.0,
      pace: json['pace'] ?? '-',
      status: json['status'] ?? 'pending',
      description: json['description'],
      date:
          json['date'] != null
              ? DateTime.tryParse(json['date'])
              : null,
    );
  }
}
