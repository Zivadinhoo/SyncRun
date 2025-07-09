import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/features/auth/screens/login_screen.dart';
import 'package:frontend/features/athlete/screens/athlete_dashboard_screen.dart';
import 'package:frontend/features/onboarding/screens/goal_section_screen.dart';
import 'package:frontend/features/onboarding/screens/target_time_screen.dart';
import 'package:frontend/features/onboarding/screens/experience_screen.dart';
import 'package:frontend/features/onboarding/screens/days_per_week_screen.dart';
import 'package:frontend/features/onboarding/screens/prefered_days_screen.dart';
import 'package:frontend/features/onboarding/screens/pick_start_date_screen.dart';
import 'package:frontend/features/onboarding/screens/noftication_screen.dart';
import 'package:frontend/features/onboarding/screens/generate_plan_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final storage = FlutterSecureStorage();

final isLoggedInProvider = FutureProvider<bool>((
  ref,
) async {
  final token = await storage.read(key: 'accessToken');
  print('🪪 Access token: $token');

  if (token == null || token.isEmpty) return false;

  try {
    final response = await http.get(
      Uri.parse('http://192.168.0.49:3001/users/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('✅ /users/me response: ${response.statusCode}');
    if (response.statusCode == 200) return true;

    await storage.deleteAll();
    return false;
  } catch (e) {
    print('❌ Error in isLoggedInProvider: $e');
    await storage.deleteAll();
    return false;
  }
});

final hasFinishedOnboardingProvider = FutureProvider<bool>((
  ref,
) async {
  final flag = await storage.read(
    key: 'hasFinishedOnboarding',
  );
  return flag == 'true';
});

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(isLoggedInProvider);
  final onboardingState = ref.watch(
    hasFinishedOnboardingProvider,
  );

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/loading',
    redirect: (context, state) {
      if (authState is AsyncLoading ||
          onboardingState is AsyncLoading) {
        return null;
      }

      final isLoggedIn = authState.value ?? false;
      final hasFinishedOnboarding =
          onboardingState.value ?? false;
      final isOnLogin = state.uri.path == '/login';
      final isOnOnboarding = state.uri.path.startsWith(
        '/onboarding',
      );

      if (!isLoggedIn && !isOnLogin) return '/login';

      if (isLoggedIn &&
          !hasFinishedOnboarding &&
          !isOnOnboarding) {
        return '/onboarding/goal';
      }

      if (isLoggedIn &&
          hasFinishedOnboarding &&
          (isOnLogin || isOnOnboarding)) {
        return '/athlete/dashboard';
      }

      if (authState.hasError) return '/login';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/athlete/dashboard',
        builder:
            (context, state) =>
                const AthleteDashboardScreen(),
      ),
      GoRoute(
        path: '/loading',
        builder:
            (context, state) => const SplashLoadingScreen(),
      ),

      /// 👇 ShellRoute for onboarding
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(body: child);
        },
        routes: [
          GoRoute(
            path: '/onboarding/goal',
            builder:
                (context, state) =>
                    const GoalSectionScreen(),
          ),
          GoRoute(
            path: '/onboarding/target-time',
            builder:
                (context, state) =>
                    const TargetTimeScreen(),
          ),
          GoRoute(
            path: '/onboarding/experience',
            builder:
                (context, state) =>
                    const ExperienceScreen(),
          ),
          GoRoute(
            path: '/onboarding/days-per-week',
            builder:
                (context, state) =>
                    const DaysPerWeekScreen(),
          ),
          GoRoute(
            path: '/onboarding/preferred-days',
            builder:
                (context, state) =>
                    const PreferredDaysScreen(),
          ),
          GoRoute(
            path: '/onboarding/start-date',
            builder:
                (context, state) => const StartDateScreen(),
          ),
          GoRoute(
            path: '/onboarding/notifications',
            builder:
                (context, state) =>
                    const NotificationScreen(),
          ),
          GoRoute(
            path: '/onboarding/generate-plan',
            builder:
                (context, state) =>
                    const GeneratePlanScreen(),
          ),
        ],
      ),
    ],
  );
});

class SplashLoadingScreen extends ConsumerWidget {
  const SplashLoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(isLoggedInProvider);

    return Scaffold(
      body: Center(
        child:
            authState.isLoading
                ? const CircularProgressIndicator()
                : const Text("Loading..."),
      ),
    );
  }
}
