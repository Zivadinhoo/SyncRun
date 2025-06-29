import 'package:flutter/material.dart';
import 'package:frontend/features/models/training_day.dart';
import 'package:intl/intl.dart';

class TrainingDayCard extends StatelessWidget {
  final TrainingDay trainingDay;
  final VoidCallback? onMarkAsDone;

  const TrainingDayCard({
    Key? key,
    required this.trainingDay,
    this.onMarkAsDone,
  }) : super(key: key);

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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'missed':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat(
      'd MMM y',
    ).format(trainingDay.date);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            _getStatusIcon(trainingDay.status),
            color: _getStatusColor(trainingDay.status),
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trainingDay.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (trainingDay.status != 'completed' &&
              onMarkAsDone != null)
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              color: theme.primaryColor,
              tooltip: 'Mark as Done',
              onPressed: onMarkAsDone,
            ),
        ],
      ),
    );
  }
}
