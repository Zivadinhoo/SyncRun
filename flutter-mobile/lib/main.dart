import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/screens/login.screen.dart';
import 'package:frontend/features/coach/screens/coach_dashboard_screen.dart';
import 'package:frontend/features/athlete/screens/athlete_main_screen.dart';
import 'package:frontend/features/common/screens/settings_screen.dart'; // 👈 Theme provider

void main() {
  runApp(const ProviderScope(child: RunWithCoachApp()));
}

class RunWithCoachApp extends ConsumerWidget {
  const RunWithCoachApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'RunWithCoach',
      themeMode: themeMode,
      theme: ThemeData(
        primaryColor: const Color(
          0xFFFFB74D,
        ), // Blaža narandžasta
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFFCC80),
          secondary: Color(0xFFFFCC80),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(
            0xFFFFF3E0,
          ), // Svetla pozadina za header
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFFFA726),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFA726),
          secondary: Color(0xFFFFCC80),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/coach-dashboard':
            (context) => const CoachDashboardScreen(),
        '/athlete-dashboard':
            (context) => const AthleteMainScreen(),
      },
    );
  }
}
