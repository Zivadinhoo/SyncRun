import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:frontend/router.dart';
import 'package:go_router/go_router.dart';

Future<void> checkPlanAndRedirect(
  BuildContext context,
  WidgetRef ref,
) async {
  final authService = AuthService();

  try {
    final user = await authService.getCurrentUser();

    ref.invalidate(isLoggedInProvider);
    ref.invalidate(hasFinishedOnboardingProvider);

    if (user != null && user['aiTrainingPlanId'] != null) {
      context.go('/athlete/dashboard');
    } else {
      context.go('/onboarding/duration');
    }
  } catch (e) {
    debugPrint('❌ Error in checkPlanAndRedirect: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Something went wrong. Please try again.',
        ),
      ),
    );
  }
}
