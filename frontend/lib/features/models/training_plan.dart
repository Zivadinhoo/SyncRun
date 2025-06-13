class TrainingPlan {
  final int id;
  final String name;
  final String description;

  TrainingPlan({
    required this.id,
    required this.name,
    required this.description,
  });

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    return TrainingPlan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
