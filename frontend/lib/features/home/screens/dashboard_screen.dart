import 'package:flutter/material.dart';
import 'package:frontend/features/home/screens/athelete/athlete_dashboard_screen.dart';
import 'package:frontend/features/home/screens/coach/coach_dashboard_screen.dart';
import 'package:frontend/models/user_role.dart';

class DashboardScreen extends StatelessWidget {
  final UserRole role;

  const DashboardScreen({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (role == UserRole.coach) {
      return const CoachDashboardScreen();
    } else {
      return const AthleteDashboardScreen();
    }
  }
}
