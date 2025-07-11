import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingAnswers {
  final String? goal; // Prikaz korisniku
  final String?
  goalTag; // Interno za AI (npr. race, health, etc.)
  final String?
  targetDistance; // 👈 Nova vrednost za distance: 5K, 10K...
  final String? targetTime;
  final String? experience;
  final int? daysPerWeek;
  final List<String>? preferredDays;
  final DateTime? startDate;
  final bool wantsNotifications;
  final String? units;

  const OnboardingAnswers({
    this.goal,
    this.goalTag,
    this.targetDistance,
    this.targetTime,
    this.experience,
    this.daysPerWeek,
    this.preferredDays,
    this.startDate,
    this.wantsNotifications = true,
    this.units,
  });

  OnboardingAnswers copyWith({
    String? goal,
    String? goalTag,
    String? targetDistance,
    String? targetTime,
    String? experience,
    int? daysPerWeek,
    List<String>? preferredDays,
    DateTime? startDate,
    bool? wantsNotifications,
    String? units,
  }) {
    return OnboardingAnswers(
      goal: goal ?? this.goal,
      goalTag: goalTag ?? this.goalTag,
      targetDistance: targetDistance ?? this.targetDistance,
      targetTime: targetTime ?? this.targetTime,
      experience: experience ?? this.experience,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      preferredDays: preferredDays ?? this.preferredDays,
      startDate: startDate ?? this.startDate,
      wantsNotifications:
          wantsNotifications ?? this.wantsNotifications,
      units: units ?? this.units,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
      'goalTag': goalTag,
      'targetDistance': targetDistance,
      'targetTime': targetTime,
      'experience': experience,
      'daysPerWeek': daysPerWeek,
      'preferredDays': preferredDays,
      'startDate': startDate?.toIso8601String(),
      'wantsNotifications': wantsNotifications,
      'units': units,
    };
  }
}

class OnboardingAnswersNotifier
    extends StateNotifier<OnboardingAnswers> {
  OnboardingAnswersNotifier()
    : super(const OnboardingAnswers());

  void setGoal(String goal, String tag) {
    state = state.copyWith(goal: goal, goalTag: tag);
  }

  void setTargetDistance(String distance) {
    state = state.copyWith(targetDistance: distance);
  }

  void setTargetTime(String time) {
    state = state.copyWith(targetTime: time);
  }

  void setExperience(String exp) {
    state = state.copyWith(experience: exp);
  }

  void setDaysPerWeek(int days) {
    state = state.copyWith(daysPerWeek: days);
  }

  void setPreferredDays(List<String> days) {
    state = state.copyWith(preferredDays: days);
  }

  void setStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void setWantsNotifications(bool wants) {
    state = state.copyWith(wantsNotifications: wants);
  }

  void setUnits(String units) {
    state = state.copyWith(units: units);
  }

  void reset() {
    state = const OnboardingAnswers();
  }
}

final onboardingAnswersProvider = StateNotifierProvider<
  OnboardingAnswersNotifier,
  OnboardingAnswers
>((ref) => OnboardingAnswersNotifier());
