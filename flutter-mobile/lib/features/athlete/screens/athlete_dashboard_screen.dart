import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/athlete/providers/active_plan_provider.dart';
import 'package:frontend/features/athlete/providers/training_days_provider.dart';
import 'package:frontend/features/athlete/providers/assigned_plans_provider.dart';
import 'package:frontend/features/athlete/screens/training_day_screen.dart';
import 'package:frontend/utils/training_day_utils.dart';
import 'package:intl/intl.dart';
import 'package:frontend/features/athlete/providers/selected_week_provider.dart';
import 'package:frontend/features/athlete/widgets/week_selector_widget.dart';
import 'package:frontend/features/athlete/providers/weekly_completion_provider.dart';
import 'package:frontend/features/athlete/screens/weekly_reward_screen.dart';

class AthleteDashboardScreen extends ConsumerWidget {
  const AthleteDashboardScreen({super.key});

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
    String status,
    BuildContext context,
  ) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'missed':
        return Colors.redAccent;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activePlanAsync = ref.watch(activePlanIdProvider);
    final assignedPlansAsync = ref.watch(
      assignedPlansFutureProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Athlete Dashboard"),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary
            .withOpacity(0.95),
        foregroundColor: Colors.white,
      ),
      body: activePlanAsync.when(
        data: (planId) {
          if (planId == null) {
            return const Center(
              child: Text("❌ No active plan assigned."),
            );
          }

          final trainingDaysAsync = ref.watch(
            trainingDaysProviderFamily(planId),
          );
          final assignedPlans =
              assignedPlansAsync.asData?.value ?? [];

          final assignedPlan = assignedPlans.firstWhere(
            (plan) => plan.id == planId,
            orElse:
                () =>
                    throw Exception(
                      "Active plan not found in assigned plans.",
                    ),
          );

          return trainingDaysAsync.when(
            data: (days) {
              final selectedWeek = ref.watch(
                selectedWeekProvider,
              );
              final grouped = groupTrainingDaysByWeek(days);
              final currentWeekDays =
                  grouped[selectedWeek] ?? [];
              final isCompleted = ref.watch(
                weeklyCompletionProvider(currentWeekDays),
              );

              if (isCompleted) {
                Future.microtask(() async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const WeeklyRewardScreen(),
                    ),
                  );
                  if (result == true &&
                      selectedWeek < grouped.length - 1) {
                    ref
                        .read(selectedWeekProvider.notifier)
                        .state++;
                  }
                });
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ACTIVE PLAN CARD
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.grey.shade900
                              : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                      border: Border.all(
                        color: theme.colorScheme.onSurface
                            .withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.directions_run,
                              color: Colors.deepOrange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Your Active Plan",
                              style: theme
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    fontWeight:
                                        FontWeight.w500,
                                    color:
                                        Colors.deepOrange,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          assignedPlan.trainingPlan.name,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    isDark
                                        ? Colors.white
                                        : null,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          assignedPlan
                              .trainingPlan
                              .description,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(
                                color:
                                    isDark
                                        ? Colors.white70
                                        : null,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // WEEK SELECTOR
                  WeekSelectorWidget(
                    currentWeek: selectedWeek,
                    totalWeeks: grouped.length,
                    onArrowPressed: (newWeek) {
                      ref
                          .read(
                            selectedWeekProvider.notifier,
                          )
                          .state = newWeek;
                    },
                  ),

                  const SizedBox(height: 12),

                  // WEEK SECTION LIST
                  if (currentWeekDays.isEmpty)
                    const Center(
                      child: Text(
                        "No training days for this week.",
                      ),
                    )
                  else
                    ...currentWeekDays.map((day) {
                      final today = DateTime.now();
                      final isToday =
                          day.date.year == today.year &&
                          day.date.month == today.month &&
                          day.date.day == today.day;

                      return InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => TrainingDayScreen(
                                    planName:
                                        assignedPlan
                                            .trainingPlan
                                            .name,
                                    planDescription:
                                        assignedPlan
                                            .trainingPlan
                                            .description,
                                    assignedAt: day.date,
                                    isCompleted:
                                        day.status ==
                                        'completed',
                                    assignedPlanId:
                                        assignedPlan.id,
                                    trainingDayId: day.id,
                                    trainingTitle:
                                        day.title,
                                    trainingDescription:
                                        day.description,
                                    duration: day.duration,
                                    tss: day.tss,
                                  ),
                            ),
                          );
                          if (result == true) {
                            ref.invalidate(
                              trainingDaysProviderFamily(
                                planId,
                              ),
                            );
                          }
                        },
                        child: Card(
                          color: theme.cardColor,
                          elevation: 3,
                          shadowColor: theme
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              16,
                            ),
                            child: Row(
                              children: [
                                // STATUS ICON
                                Container(
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      day.status,
                                      context,
                                    ).withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  padding:
                                      const EdgeInsets.all(
                                        8,
                                      ),
                                  child: Icon(
                                    _getStatusIcon(
                                      day.status,
                                    ),
                                    color: _getStatusColor(
                                      day.status,
                                      context,
                                    ),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // INFO
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              day.title,
                                              style: theme
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                          if (isToday)
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(
                                                    left: 8,
                                                  ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal:
                                                        8,
                                                    vertical:
                                                        2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: theme
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(
                                                      0.1,
                                                    ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      20,
                                                    ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .today,
                                                    size:
                                                        14,
                                                    color:
                                                        theme.colorScheme.primary,
                                                  ),
                                                  const SizedBox(
                                                    width:
                                                        4,
                                                  ),
                                                  Text(
                                                    "Today",
                                                    style: TextStyle(
                                                      fontSize:
                                                          12,
                                                      color:
                                                          theme.colorScheme.primary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (day
                                                  .feedback
                                                  ?.comment
                                                  ?.isNotEmpty ==
                                              true)
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(
                                                    left: 8,
                                                  ),
                                              child: Icon(
                                                Icons
                                                    .comment,
                                                size: 18,
                                                color:
                                                    Colors
                                                        .blueGrey,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons
                                                .calendar_today,
                                            size: 14,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                style: theme
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color:
                                                          theme.hintColor,
                                                    ),
                                                children: [
                                                  TextSpan(
                                                    text: DateFormat(
                                                      'EEE',
                                                    ).format(
                                                      day.date,
                                                    ),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const TextSpan(
                                                    text:
                                                        ' · ',
                                                  ),
                                                  TextSpan(
                                                    text: DateFormat(
                                                      'MMM d',
                                                    ).format(
                                                      day.date,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color:
                                      theme
                                          .colorScheme
                                          .primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                ],
              );
            },
            loading:
                () => const Center(
                  child: CircularProgressIndicator(),
                ),
            error:
                (err, _) => Center(child: Text("❌ $err")),
          );
        },
        loading:
            () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (err, _) => Center(child: Text("❌ $err")),
      ),
    );
  }
}
