import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/features/models/assigned_plan.dart';

class TrainingPlanCard extends StatelessWidget {
  final AssignedPlan plan;
  final VoidCallback onTap;

  const TrainingPlanCard({
    super.key,
    required this.plan,
    required this.onTap,
    required bool isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Row(
            children: [
              // Leva strana: info
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.trainingPlan.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Assigned: ${DateFormat('EEE, d MMM').format(plan.assignedAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    if (plan.tss != null ||
                        plan.rpe != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 2,
                        ),
                        child: Text(
                          'TSS: ${plan.tss?.toStringAsFixed(0) ?? '-'} — RPE: ${plan.rpe?.toString() ?? '-'}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Desna strana: status
              Row(
                children: [
                  Icon(
                    plan.isCompleted
                        ? Icons.check_circle
                        : Icons.schedule,
                    color:
                        plan.isCompleted
                            ? Colors.green
                            : Colors.orange,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    plan.isCompleted ? 'Done' : 'Pending',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          plan.isCompleted
                              ? Colors.green
                              : Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
