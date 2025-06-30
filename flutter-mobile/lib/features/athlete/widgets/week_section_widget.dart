import 'package:flutter/material.dart';
import 'package:frontend/features/models/training_day.dart';

class WeekSectionWidget extends StatelessWidget {
  final int weekNumber;
  final List<TrainingDay> days;
  final Widget Function(TrainingDay) dayBuilder;

  const WeekSectionWidget({
    super.key,
    required this.weekNumber,
    required this.days,
    required this.dayBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox();

    final DateTime start = days.first.date;
    final DateTime end = days.last.date;

    final String formattedRange =
        "${_formatDate(start)} – ${_formatDate(end)}";

    // 👇 Dodato za progress
    final int total = days.length;
    final int completed =
        days.where((d) => d.status == 'completed').length;
    final double progress =
        total == 0 ? 0 : completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Week $weekNumber ($formattedRange)",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),

        // 👇 Progress bar po nedelji
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade300,
                color: Colors.green,
                minHeight: 6,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "$completed/$total",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        ...days.map(dayBuilder).toList(),
        const SizedBox(height: 20),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${_monthName(date.month)} ${date.day}";
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}
