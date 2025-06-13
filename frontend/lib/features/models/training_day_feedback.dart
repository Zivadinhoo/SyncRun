class TrainingDayFeedback {
  final int id;
  final String comment;
  final int rating;
  final int trainingDayId;

  TrainingDayFeedback({
    required this.id,
    required this.comment,
    required this.rating,
    required this.trainingDayId,
  });

  factory TrainingDayFeedback.fromJson(
    Map<String, dynamic> json,
  ) {
    return TrainingDayFeedback(
      id: json['id'],
      comment: json['comment'] ?? '',
      rating: json['rating'] ?? 5,
      trainingDayId: json['trainingDay']['id'],
    );
  }
}
