import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/screens/login.screen.dart';
import 'package:frontend/features/coach/screens/coach_dashboard_screen.dart';
import 'package:frontend/features/plans/screens/create_plan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ProviderScope(child: RunWithCoachApp()));
}

class RunWithCoachApp extends StatefulWidget {
  const RunWithCoachApp({Key? key}) : super(key: key);

  @override
  State<RunWithCoachApp> createState() =>
      _RunWithCoachAppState();
}

class _RunWithCoachAppState extends State<RunWithCoachApp> {
  bool isAuthenticated = false;
  String? token;

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString("authToken");

    if (storedToken != null && storedToken.isNotEmpty) {
      setState(() {
        isAuthenticated = true;
        token = storedToken;
      });
    }
  }

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
      initialRoute:
          isAuthenticated ? '/coach-dashboard' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/coach-dashboard':
            (context) => const CoachDashboardScreen(),
        '/create-plan':
            (context) => const CreatePlanScreen(),
      },
    );
  }
}
