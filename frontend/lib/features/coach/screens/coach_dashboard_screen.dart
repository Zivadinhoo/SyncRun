import 'package:flutter/material.dart';

class CoachDashboardScreen extends StatelessWidget {
  const CoachDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome Coach',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
