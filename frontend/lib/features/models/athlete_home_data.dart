class AthleteHomeData {
  final String userName;
  final String profileImagePath;
  final String currentPlanName;
  final String nextTraining;
  final double progressPercent;

  AthleteHomeData({
    required this.userName,
    required this.profileImagePath,
    required this.currentPlanName,
    required this.nextTraining,
    required this.progressPercent,
  });

  factory AthleteHomeData.fromJson(Map<String, dynamic> json) {
    return AthleteHomeData(
      userName: json['userName'] ?? 'Unknown',
      profileImagePath: 'assets/images/urosTrci.jpeg',
      currentPlanName: json['currentPlanName'] ?? 'No plan',
      nextTraining: json['nextTraining'] ?? 'Rest day',
      progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
