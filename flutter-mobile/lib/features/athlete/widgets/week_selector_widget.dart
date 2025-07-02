import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/athlete/providers/selected_week_provider.dart';

class WeekSelectorWidget extends ConsumerWidget {
  final int currentWeek;
  final int totalWeeks;

  const WeekSelectorWidget({
    super.key,
    required this.currentWeek,
    required this.totalWeeks,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(
            0.15,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed:
                currentWeek > 1
                    ? () =>
                        ref
                            .read(
                              selectedWeekProvider.notifier,
                            )
                            .state--
                    : null,
          ),
          Text(
            "Week $currentWeek of $totalWeeks",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed:
                currentWeek < totalWeeks
                    ? () =>
                        ref
                            .read(
                              selectedWeekProvider.notifier,
                            )
                            .state++
                    : null,
          ),
        ],
      ),
    );
  }
}
