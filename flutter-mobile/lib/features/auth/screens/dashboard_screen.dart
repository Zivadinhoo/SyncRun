import 'package:flutter/material.dart';
import 'package:frontend/features/athelete/screens/athlete_dashboard_screen.dart';
import 'package:frontend/features/auth/screens/login.screen.dart';
import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:frontend/features/coach/screens/coach_dashboard_screen.dart';
import 'package:frontend/features/models/user_role.dart';

class DashboardScreen extends StatelessWidget {
  final UserRole role;

  const DashboardScreen({Key? key, required this.role})
    : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(role, context),
      body:
          role == UserRole.coach
              ? const CoachDashboardScreen()
              : const AthleteDashboardScreen(),
    );
  }

  AppBar _buildAppBar(UserRole role, BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFDF6F1),
      elevation: 0,
      centerTitle: true,
      title: Text(
        role == UserRole.coach
            ? 'Coach Dashboard'
            : 'Athlete Dashboard',
        style: const TextStyle(color: Colors.black87),
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _logout(context),
        ),
      ],
    );
  }
}
