import 'package:flutter/material.dart';
import 'package:frontend/features/models/weekly_review.dart';

class WeeklyDayTile extends StatelessWidget {
  final TrainingDaySummary day;

  const WeeklyDayTile({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
          ),
          title: Text(day.title),
          subtitle: Text(
            'TSS: ${day.tss} — RPE: ${day.rating}',
          ),
          trailing: Icon(
            day.isCompleted ? Icons.check : Icons.schedule,
            color:
                day.isCompleted
                    ? Colors.green
                    : Colors.grey,
          ),
        ),
        const Divider(height: 1, thickness: 0.5),
      ],
    );
  }
}
