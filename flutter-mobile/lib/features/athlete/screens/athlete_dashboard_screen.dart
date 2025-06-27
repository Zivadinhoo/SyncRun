import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/athlete/providers/active_plan_provider.dart';
import 'package:frontend/features/athlete/providers/training_days_provider.dart';
import 'package:frontend/features/athlete/providers/assigned_plans_provider.dart';
import 'package:frontend/features/models/training_day.dart';
import 'package:frontend/features/athlete/screens/training_day_screen.dart';

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
                          // ignore: deprecated_member_use
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
                    ...List.generate(days.length, (index) {
                      final day = days[index];
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
                                BorderRadius.circular(12),
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
                                Icon(
                                  _getStatusIcon(
                                    day.status,
                                  ),
                                  color: _getStatusColor(
                                    day.status,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        "Training Day ${index + 1}: ${day.title}",
                                        style:
                                            const TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                      ),
                                      Text(
                                        "Date: ${day.date.toIso8601String().split("T").first}",
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ),
                        ),
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
