import 'package:flutter/material.dart';
import 'package:frontend/features/models/training_day.dart';

class WeekProgressWidget extends StatelessWidget {
  final List<TrainingDay> currentWeekDays;

  const WeekProgressWidget({
    super.key,
    required this.currentWeekDays,
  });

  @override
  Widget build(BuildContext context) {
    // Ispravljeno ovde 👇
    final completed =
        currentWeekDays
            .where((td) => td.status == 'completed')
            .length;
    final total = currentWeekDays.length;
    final percent =
        total == 0
            ? 0
            : ((completed / total) * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            Icons.track_changes,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            "$completed / $total Completed ($percent%)",
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
