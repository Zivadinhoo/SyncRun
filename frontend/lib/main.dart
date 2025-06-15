import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/screens/login.screen.dart';
import 'package:frontend/features/coach/screens/coach_dashboard_screen.dart';
import 'package:frontend/features/plans/screens/create_plan_screen.dart';

import 'package:frontend/features/athelete/screens/athlete_main_screen.dart';

void main() {
  runApp(const ProviderScope(child: RunWithCoachApp()));
}

class RunWithCoachApp extends StatelessWidget {
  const RunWithCoachApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RunWithCoach',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/coach-dashboard':
            (context) => const CoachDashboardScreen(),
        '/create-plan':
            (context) => const CreatePlanScreen(),
        '/athlete-dashboard':
            (context) => const AthleteMainScreen(),
      },
    );
  }
}
