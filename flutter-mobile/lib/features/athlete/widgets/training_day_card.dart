import 'package:flutter/material.dart';
import 'package:frontend/features/models/training_day.dart';
import 'package:intl/intl.dart';

class TrainingDayCard extends StatelessWidget {
  final TrainingDay trainingDay;
  final VoidCallback? onMarkAsDone;

  const TrainingDayCard({
    super.key,
    required this.trainingDay,
    this.onMarkAsDone,
  });

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'missed':
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }

  Color _getStatusColor(
    BuildContext context,
    String status,
  ) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'missed':
        return Colors.redAccent;
      default:
        return Theme.of(
          context,
        ).colorScheme.onSurface.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat(
      'EEE · MMM d',
    ).format(trainingDay.date);
    // Primer: Tue · Jul 1

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            _getStatusIcon(trainingDay.status),
            color: _getStatusColor(
              context,
              trainingDay.status,
            ),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trainingDay.title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formattedDate,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(
                            color: theme
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (trainingDay.status != 'completed' &&
              onMarkAsDone != null)
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
              color: theme.colorScheme.primary,
              tooltip: 'Go to Training',
              onPressed: onMarkAsDone,
            ),
        ],
      ),
    );
  }
}
