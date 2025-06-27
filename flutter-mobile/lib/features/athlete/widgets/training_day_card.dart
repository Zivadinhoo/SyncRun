import 'package:flutter/material.dart';
import 'package:frontend/features/models/training_day.dart';

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
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        title: Text(
          trainingDay.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Date: ${trainingDay.date.toLocal().toString().split(' ')[0]}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: trainingDay.status,
              child: Icon(
                _getStatusIcon(trainingDay.status),
                color: _getStatusColor(trainingDay.status),
              ),
            ),
            const SizedBox(width: 12),
            if (trainingDay.status != 'completed' &&
                onMarkAsDone != null)
              IconButton(
                icon: const Icon(Icons.check),
                tooltip: 'Mark as Done',
                onPressed: onMarkAsDone,
              ),
          ],
        ),
      ),
    );
  }
}
