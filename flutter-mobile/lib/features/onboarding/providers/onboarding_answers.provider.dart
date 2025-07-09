import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingAnswers {
  final String? goal;
  final String? targetTime;
  final String? experience;
  final int? daysPerWeek;
  final List<String>? preferredDays;
  final DateTime? startDate;
  final bool wantsNotifications;

  const OnboardingAnswers({
    this.goal,
    this.targetTime,
    this.experience,
    this.daysPerWeek,
    this.preferredDays,
    this.startDate,
    this.wantsNotifications = true,
  });

  OnboardingAnswers copyWith({
    String? goal,
    String? targetTime,
    String? experience,
    int? daysPerWeek,
    List<String>? preferredDays,
    DateTime? startDate,
    bool? wantsNotifications,
  }) {
    return OnboardingAnswers(
      goal: goal ?? this.goal,
      targetTime: targetTime ?? this.targetTime,
      experience: experience ?? this.experience,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      preferredDays: preferredDays ?? this.preferredDays,
      startDate: startDate ?? this.startDate,
      wantsNotifications:
          wantsNotifications ?? this.wantsNotifications,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
      'targetTime': targetTime,
      'experience': experience,
      'daysPerWeek': daysPerWeek,
      'preferredDays': preferredDays,
      'startDate': startDate?.toIso8601String(),
      'wantsNotifications': wantsNotifications,
    };
  }
}

class OnboardingAnswersNotifier
    extends StateNotifier<OnboardingAnswers> {
  OnboardingAnswersNotifier()
    : super(const OnboardingAnswers());

  void setGoal(String goal) {
    state = state.copyWith(goal: goal);
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

  void reset() {
    state = const OnboardingAnswers();
  }
}

final onboardingAnswersProvider = StateNotifierProvider<
  OnboardingAnswersNotifier,
  OnboardingAnswers
>((ref) => OnboardingAnswersNotifier());
