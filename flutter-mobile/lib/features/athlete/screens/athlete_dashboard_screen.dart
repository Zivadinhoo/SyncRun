import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/athlete/providers/active_plan_provider.dart';
import 'package:frontend/features/athlete/providers/training_days_provider.dart';
import 'package:frontend/features/athlete/providers/assigned_plans_provider.dart';
import 'package:frontend/features/models/training_day.dart';

class AthleteDashboardScreen extends ConsumerWidget {
  const AthleteDashboardScreen({super.key});

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
                  // 🟧 PLAN NAME & DESCRIPTION
                  Text(
                    assignedPlan.trainingPlan.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...[
                    const SizedBox(height: 4),
                    Text(
                      assignedPlan
                          .trainingPlan
                          .description!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // 📆 TRAINING DAYS
                  if (days.isEmpty)
                    const Center(
                      child: Text("No training days yet."),
                    )
                  else
                    ...List.generate(days.length, (index) {
                      final day = days[index];
                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: ListTile(
                          title: Text(
                            "Training Day ${index + 1}: ${day.title}",
                          ),
                          subtitle: Text(
                            "Date: ${day.date.toIso8601String().split('T').first}",
                          ),
                          trailing: Icon(
                            day.isCompleted
                                ? Icons.check_circle
                                : Icons
                                    .radio_button_unchecked,
                            color:
                                day.isCompleted
                                    ? Colors.green
                                    : Colors.orange,
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
