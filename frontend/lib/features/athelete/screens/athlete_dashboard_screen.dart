import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/assigned_plans_provider.dart';
import 'package:frontend/models/assigned_plan.dart';

class AthleteDashboardScreen extends ConsumerWidget {
  const AthleteDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignedPlansAsync = ref.watch(
      assignedPlansFutureProvider,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF6F1),
        elevation: 0,
        title: const Text(
          'Athlete Dashboard',
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
        centerTitle: true,
      ),
      body: assignedPlansAsync.when(
        data: (plans) {
          if (plans.isEmpty) {
            return const Center(
              child: Text(
                'No assigned training plans yet.',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: ListTile(
                  title: Text(plan.trainingPlan.name),
                  subtitle: Text(
                    plan.trainingPlan.description,
                  ),
                  trailing: Icon(
                    plan.isCompleted
                        ? Icons.check_circle
                        : Icons.schedule,
                    color:
                        plan.isCompleted
                            ? Colors.green
                            : Colors.orange,
                  ),
                ),
              );
            },
          );
        },
        loading:
            () => const Center(
              child: CircularProgressIndicator(),
            ),
        error:
            (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
