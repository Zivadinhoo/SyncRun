import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklySummaryHeader extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  const WeeklySummaryHeader({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${DateFormat('d MMM').format(startDate)} - ${DateFormat('d MMM').format(endDate)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "📊 Weekly Summary",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onPreviousWeek,
            ),
            Text(
              formatted,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: onNextWeek,
            ),
          ],
        ),
      ],
    );
  }
}
