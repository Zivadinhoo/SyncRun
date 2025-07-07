import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/models/onboarding_answer.dart';

final onboardingAnswersProvider =
    StateProvider<OnboardingAnswers>((ref) {
      return OnboardingAnswers();
    });
