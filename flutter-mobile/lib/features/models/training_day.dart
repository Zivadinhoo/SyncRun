class TrainingDay {
  final String day; // e.g. "Monday"
  final String type; // e.g. "Easy Run"
  final double distance; // in km
  final String? pace; // e.g. "5:30 min/KM"
  final String status; // "pending", "completed"
  final String? description;
  final DateTime? date;
  final int? id;

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
          (json['distance'] is num)
              ? (json['distance'] as num).toDouble()
              : 0.0,
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
