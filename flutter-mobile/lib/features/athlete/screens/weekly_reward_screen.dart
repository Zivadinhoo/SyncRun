import 'package:flutter/material.dart';

class WeeklyRewardScreen extends StatefulWidget {
  const WeeklyRewardScreen({super.key});

  @override
  State<WeeklyRewardScreen> createState() =>
      _WeeklyRewardScreenState();
}

class _WeeklyRewardScreenState
    extends State<WeeklyRewardScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-close after 2 seconds and return `true` to trigger next week
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark
              ? Colors.grey.shade900
              : Colors.orange.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: 100,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                "🎉 Week Completed!",
                style: theme.textTheme.headlineMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Amazing consistency! You completed all your workouts this week.\n\nThe hardest part is staying committed — and you're doing it. 💪",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
