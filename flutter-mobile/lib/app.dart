import 'package:flutter/material.dart';
import 'package:frontend/features/auth/screens/dashboard_screen.dart';
import 'package:frontend/features/models/user_role.dart';

class RunWithCoachApp extends StatelessWidget {
  const RunWithCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    final UserRole userRole = UserRole.coach;

    return MaterialApp(
      title: 'Syncrun',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),
        useMaterial3: true,
      ),
      home: DashboardScreen(role: userRole),
    );
  }
}
