class WeeklyReview {
  final List<TrainingDaySummary> days;
  final double totalTSS;
  final int completedDuration;
  final double averageRPE;

  WeeklyReview({
    required this.days,
    required this.totalTSS,
    required this.completedDuration,
    required this.averageRPE,
  });

  factory WeeklyReview.fromJson(Map<String, dynamic> json) {
    return WeeklyReview(
      days:
          (json['days'] as List<dynamic>)
              .map((e) => TrainingDaySummary.fromJson(e))
              .toList(),
      totalTSS: (json['totalTSS'] as num).toDouble(),
      completedDuration: json['completedDuration'] as int,
      averageRPE: (json['averageRPE'] as num).toDouble(),
    );
  }
}

class TrainingDaySummary {
  final int id;
  final String date;
  final String title;
  final String? description;
  final bool isCompleted;
  final int duration;
  final int rating;
  final String comment;
  final double tss;

  TrainingDaySummary({
    required this.id,
    required this.date,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.duration,
    required this.rating,
    required this.comment,
    required this.tss,
  });

  factory TrainingDaySummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return TrainingDaySummary(
      id: json['id'],
      date: json['date'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      duration: json['duration'],
      rating: json['rating'],
      comment: json['comment'],
      tss: (json['tss'] as num).toDouble(),
    );
  }
}
