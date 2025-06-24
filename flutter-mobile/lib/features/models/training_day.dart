class TrainingDay {
  final int id;
  final DateTime date;
  final String title;
  final String description;
  final int duration;
  final double? tss;

  TrainingDay({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.duration,
    this.tss,
  });

  factory TrainingDay.fromJson(Map<String, dynamic> json) {
    return TrainingDay(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      tss: json['tss']?.toDouble(),
    );
  }
}
