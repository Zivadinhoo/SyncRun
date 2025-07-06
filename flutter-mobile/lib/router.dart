import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/onboarding/screens/goal_section_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/onboarding/goal',
  routes: [
    GoRoute(
      path: '/onboarding/goal',
      builder:
          (context, state) => const GoalSelectionScreen(),
    ),
    // Dodavaćemo ostale rute ovde
  ],
);
