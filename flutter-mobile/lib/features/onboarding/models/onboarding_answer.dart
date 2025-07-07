class OnboardingAnswers {
  final String? goal;
  final String? targetTime;
  final int? weeklyRuns;
  final String? currentPb;
  final List<String>? preferredDays;
  final bool? notificationsEnabled;
  final DateTime? startDate;
  final String? units;

  OnboardingAnswers({
    this.goal,
    this.targetTime,
    this.weeklyRuns,
    this.currentPb,
    this.preferredDays,
    this.notificationsEnabled,
    this.startDate,
    this.units,
  });

  OnboardingAnswers copyWith({
    String? goal,
    String? targetTime,
    int? weeklyRuns,
    String? currentPb,
    List<String>? preferredDays,
    bool? notificationsEnabled,
    DateTime? startDate,
    String? units,
  }) {
    return OnboardingAnswers(
      goal: goal ?? this.goal,
      targetTime: targetTime ?? this.targetTime,
      weeklyRuns: weeklyRuns ?? this.weeklyRuns,
      currentPb: currentPb ?? this.currentPb,
      preferredDays: preferredDays ?? this.preferredDays,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      startDate: startDate ?? this.startDate,
      units: units ?? this.units,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
      'targetTime': targetTime,
      'weeklyRuns': weeklyRuns,
      'currentPb': currentPb,
      'preferredDays': preferredDays,
      'notificationsEnabled': notificationsEnabled,
      'startDate': startDate?.toIso8601String(),
      'units': units,
    };
  }
}
