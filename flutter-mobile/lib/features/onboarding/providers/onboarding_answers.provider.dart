import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingAnswers {
  final String?
  goal; // "5K", "10K", "Half Marathon", "Marathon"
  final String? targetTime; // "1:35", etc.
  final int? weeklyRuns;
  final String? currentPb;

  OnboardingAnswers({
    this.goal,
    this.targetTime,
    this.weeklyRuns,
    this.currentPb,
  });

  OnboardingAnswers copyWith({
    String? goal,
    String? targetTime,
    int? weeklyRuns,
    String? currentPb,
  }) {
    return OnboardingAnswers(
      goal: goal ?? this.goal,
      targetTime: targetTime ?? this.targetTime,
      weeklyRuns: weeklyRuns ?? this.weeklyRuns,
      currentPb: currentPb ?? this.currentPb,
    );
  }
}

final onboardingAnswersProvider =
    StateProvider<OnboardingAnswers>((ref) {
      return OnboardingAnswers();
    });
