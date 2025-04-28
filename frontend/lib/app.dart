import 'package:flutter/material.dart';
import 'package:frontend/features/auth/screens/auth_gate.dart';
import 'package:frontend/features/home/screens/dashboard_screen.dart';

class RunWithCoachApp extends StatelessWidget {
  const RunWithCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RunWithCoach',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
