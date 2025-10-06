import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/onboarding/screens/plan_duration_screen.dart';
import 'package:frontend/features/athlete/screens/training_day_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

// Screens
import 'package:frontend/features/auth/screens/login_screen.dart';
import 'package:frontend/features/athlete/screens/athlete_main_screen.dart';
import 'package:frontend/features/onboarding/screens/goal_section_screen.dart';
import 'package:frontend/features/onboarding/screens/target_distance_screen.dart';
import 'package:frontend/features/onboarding/screens/experience_screen.dart';
import 'package:frontend/features/onboarding/screens/days_per_week_screen.dart';
import 'package:frontend/features/onboarding/screens/prefered_days_screen.dart';
import 'package:frontend/features/onboarding/screens/start_date_screen.dart';
import 'package:frontend/features/onboarding/screens/units_screen.dart';
import 'package:frontend/features/onboarding/screens/noftication_screen.dart';
import 'package:frontend/features/onboarding/screens/generate_plan_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final storage = FlutterSecureStorage();

final isLoggedInProvider = FutureProvider.autoDispose<bool>(
  (ref) async {
    final token = await storage.read(key: 'accessToken');
    if (token == null || token.isEmpty) return false;

    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.57:3001/users/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) return true;
      await storage.deleteAll();
      return false;
    } catch (e) {
      await storage.deleteAll();
      return false;
    }
  },
);

final hasFinishedOnboardingProvider =
    FutureProvider.autoDispose<bool>((ref) async {
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
    debugLogDiagnostics: true,
    initialLocation: '/',
    redirect: (context, state) {
      if (authState is AsyncLoading ||
          onboardingState is AsyncLoading) {
        return null;
      }

      if (authState.hasError || onboardingState.hasError) {
        return '/login';
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

      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/loading'),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/loading',
        builder:
            (context, state) => const SplashLoadingScreen(),
      ),
      GoRoute(
        path: '/athlete/dashboard',
        builder:
            (context, state) => const AthleteMainScreen(),
      ),
      GoRoute(
        path: '/training-day/:id',
        builder: (context, state) {
          final idParam = state.pathParameters['id'];
          final trainingDayId = int.tryParse(idParam ?? '');

          if (trainingDayId == null) {
            return const Scaffold(
              body: Center(
                child: Text('❌ Invalid training day ID'),
              ),
            );
          }

          return TrainingDayScreen(
            trainingDayId: trainingDayId,
          );
        },
      ),
      ShellRoute(
        builder:
            (context, state, child) =>
                Scaffold(body: child),
        routes: [
          GoRoute(
            path: '/onboarding/goal',
            builder:
                (context, state) =>
                    const GoalSectionScreen(),
          ),
          GoRoute(
            path: '/onboarding/target-distance',
            builder:
                (context, state) =>
                    const TargetDistanceScreen(),
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
            path: '/onboarding/units',
            builder:
                (context, state) => const UnitsScreen(),
          ),
          GoRoute(
            path: '/onboarding/notifications',
            builder:
                (context, state) =>
                    const NotificationScreen(),
          ),
          GoRoute(
            path: '/onboarding/plan-duration',
            builder:
                (context, state) =>
                    const PlanDurationScreen(),
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
    final onboardingState = ref.watch(
      hasFinishedOnboardingProvider,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isLoggedIn = authState.value ?? false;
      final hasFinishedOnboarding =
          onboardingState.value ?? false;

      if (!authState.isLoading &&
          !onboardingState.isLoading) {
        if (!isLoggedIn) {
          context.go('/login');
        } else if (!hasFinishedOnboarding) {
          context.go('/onboarding/goal');
        } else {
          context.go('/athlete/dashboard');
        }
      }
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
