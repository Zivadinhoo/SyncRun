import 'package:flutter/material.dart';

class WeekSectionSwitcher extends StatelessWidget {
  final int currentWeek;
  final int totalWeeks;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const WeekSectionSwitcher({
    super.key,
    required this.currentWeek,
    required this.totalWeeks,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: currentWeek > 1 ? onPrevious : null,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Text(
          'Week $currentWeek',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed:
              currentWeek < totalWeeks ? onNext : null,
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }
}
