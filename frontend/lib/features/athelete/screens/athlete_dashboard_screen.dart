import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../providers/assigned_plans_provider.dart';
import 'training_day_screen.dart';

class AthleteDashboardScreen
    extends ConsumerStatefulWidget {
  const AthleteDashboardScreen({super.key});

  @override
  ConsumerState<AthleteDashboardScreen> createState() =>
      _AthleteDashboardScreenState();
}

class _AthleteDashboardScreenState
    extends ConsumerState<AthleteDashboardScreen> {
  final _storage = const FlutterSecureStorage();
  String fullName = '';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final name = await _storage.read(key: 'fullName');
    setState(() {
      fullName = name ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final assignedPlansAsync = ref.watch(
      assignedPlansFutureProvider,
    );

    return SafeArea(
      child: Column(
        children: [
          Container(
            color: const Color(0xFFFDF6F1),
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            alignment: Alignment.center,
            child: Text(
              fullName.isNotEmpty
                  ? 'Welcome $fullName'
                  : 'Welcome',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: assignedPlansAsync.when(
              data: (plans) {
                final validPlans =
                    plans
                        .where(
                          (p) => p.trainingPlan != null,
                        )
                        .toList();

                if (validPlans.isEmpty) {
                  return const Center(
                    child: Text(
                      'No assigned training plans yet.',
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: validPlans.length,
                  itemBuilder: (context, index) {
                    final plan = validPlans[index];

                    return GestureDetector(
                      onTap: () async {
                        if (plan.trainingDayId == null ||
                            plan.trainingDayId == 0) {
                          print(
                            "⚠️ No valid trainingDayId provided.",
                          );
                          return;
                        }

                        final trainingDayId =
                            plan.trainingDayId!;

                        final result = await Navigator.push<
                          bool
                        >(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => TrainingDayScreen(
                                  planName:
                                      plan
                                          .trainingPlan
                                          .name,
                                  planDescription:
                                      plan
                                          .trainingPlan
                                          .description,
                                  assignedAt:
                                      plan.assignedAt,
                                  isCompleted:
                                      plan.isCompleted,
                                  assignedPlanId: plan.id,
                                  trainingDayId:
                                      trainingDayId,
                                ),
                          ),
                        );

                        if (result == true) {
                          ref.invalidate(
                            assignedPlansFutureProvider,
                          );
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.trainingPlan.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                plan
                                    .trainingPlan
                                    .description,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: [
                                  Text(
                                    'Assigned: ${DateFormat('d. MMM y').format(plan.assignedAt)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        plan.isCompleted
                                            ? Icons
                                                .check_circle
                                            : Icons
                                                .schedule,
                                        color:
                                            plan.isCompleted
                                                ? Colors
                                                    .green
                                                : Colors
                                                    .orange,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        plan.isCompleted
                                            ? 'Completed'
                                            : 'Not completed',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              plan.isCompleted
                                                  ? Colors
                                                      .green
                                                  : Colors
                                                      .orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                  (err, _) =>
                      Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
