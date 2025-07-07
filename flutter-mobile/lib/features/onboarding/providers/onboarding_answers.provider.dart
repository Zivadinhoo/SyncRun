import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingAnswers {
  final String? goal; // e.g. "5K", "10K", etc.
  final String? targetTime;
  final int? weeklyRuns;
  final String? currentPb;
  final List<String>? preferredDays;
  final bool? notificationsEnabled;
  final DateTime? startDate;
  final String? units; // "km" or "mi"

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
}

final onboardingAnswersProvider =
    StateProvider<OnboardingAnswers>((ref) {
      return OnboardingAnswers();
    });
