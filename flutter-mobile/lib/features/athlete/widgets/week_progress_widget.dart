import 'package:flutter/material.dart';

class WeeklyProgressWidget extends StatelessWidget {
  final int completed;
  final int total;

  const WeeklyProgressWidget({
    super.key,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : completed / total;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.show_chart,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                'Weekly Progress',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          LinearProgressIndicator(
            value: percent,
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.orange,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 12),

          // Bottom text
          Text(
            total == 0
                ? 'No workouts scheduled this week'
                : '$completed of $total workouts completed (${(percent * 100).toStringAsFixed(0)}%)',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
