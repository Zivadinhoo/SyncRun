import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/athlete/providers/active_plan_provider.dart';
import 'package:frontend/features/athlete/providers/training_days_provider.dart';
import 'package:frontend/features/athlete/providers/assigned_plans_provider.dart';
import 'package:frontend/features/athlete/widgets/week_section_widget.dart';
import 'package:frontend/features/models/training_day.dart';
import 'package:frontend/features/athlete/screens/training_day_screen.dart';
import 'package:frontend/utils/training_day_utils.dart';

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
  Widget build(BuildContext context, WidgetRef ref) {
    final activePlanAsync = ref.watch(activePlanIdProvider);
    final assignedPlansAsync = ref.watch(
      assignedPlansFutureProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Athlete Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.orange.shade100,
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
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(
                            0.1,
                          ),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🏃 ${assignedPlan.trainingPlan.name}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          assignedPlan
                              .trainingPlan
                              .description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (days.isEmpty)
                    const Center(
                      child: Text("No training days yet."),
                    )
                  else
                    ...groupTrainingDaysByWeek(
                      days,
                    ).entries.map((entry) {
                      final weekNumber = entry.key;
                      final weekDays = entry.value;

                      return WeekSectionWidget(
                        weekNumber: weekNumber,
                        days: weekDays,
                        dayBuilder: (day) {
                          final today = DateTime.now();
                          final isToday =
                              day.date.year == today.year &&
                              day.date.month ==
                                  today.month &&
                              day.date.day == today.day;

                          return InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (
                                        _,
                                      ) => TrainingDayScreen(
                                        planName:
                                            assignedPlan
                                                .trainingPlan
                                                .name,
                                        planDescription:
                                            assignedPlan
                                                .trainingPlan
                                                .description,
                                        assignedAt:
                                            day.date,
                                        isCompleted:
                                            day.status ==
                                            'completed',
                                        assignedPlanId:
                                            assignedPlan.id,
                                        trainingDayId:
                                            day.id,
                                        trainingTitle:
                                            day.title,
                                        trainingDescription:
                                            day.description,
                                        duration:
                                            day.duration,
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
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      12,
                                    ),
                              ),
                              margin: const EdgeInsets.only(
                                bottom: 12,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(
                                      16,
                                    ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _getStatusIcon(
                                        day.status,
                                      ),
                                      color:
                                          _getStatusColor(
                                            day.status,
                                          ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Training: ${day.title}",
                                                style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                ),
                                              ),
                                              if (isToday)
                                                Container(
                                                  margin:
                                                      const EdgeInsets.only(
                                                        left:
                                                            8,
                                                      ),
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal:
                                                        8,
                                                    vertical:
                                                        2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.orange.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    "Today",
                                                    style: TextStyle(
                                                      fontSize:
                                                          12,
                                                      color:
                                                          Colors.orange,
                                                    ),
                                                  ),
                                                ),
                                              if (day
                                                      .feedback
                                                      ?.comment
                                                      .isNotEmpty ==
                                                  true)
                                                const Padding(
                                                  padding:
                                                      EdgeInsets.only(
                                                        left:
                                                            8,
                                                      ),
                                                  child: Icon(
                                                    Icons
                                                        .comment,
                                                    size:
                                                        16,
                                                    color:
                                                        Colors.grey,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Text(
                                            "Date: ${day.date.toIso8601String().split("T").first}",
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons
                                          .arrow_forward_ios,
                                      size: 16,
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                ],
              );
            },
            loading:
                () => const Center(
                  child: CircularProgressIndicator(),
                ),
            error:
                (err, stack) =>
                    Center(child: Text("❌ $err")),
          );
        },
        loading:
            () => const Center(
              child: CircularProgressIndicator(),
            ),
        error:
            (err, stack) => Center(child: Text("❌ $err")),
      ),
    );
  }
}
