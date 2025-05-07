import 'package:flutter/material.dart';

class AthleteDashboardScreen extends StatelessWidget {
  const AthleteDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome Athlete',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
