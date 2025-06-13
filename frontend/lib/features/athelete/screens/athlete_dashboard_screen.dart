import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/athelete/providers/weekly_review_provider.dart';
import 'package:frontend/features/athelete/widgets/weekly_tss_bar_chart.dart';
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
  DateTime currentStartDate = _getStartOfWeek(
    DateTime.now(),
  );
  late WeeklyReviewParams _weeklyParams;

  static DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  void _updateWeeklyParams() {
    final startDate = currentStartDate;
    final endDate = startDate.add(const Duration(days: 6));
    const athleteId = 4;

    _weeklyParams = WeeklyReviewParams(
      athleteId: athleteId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  void _previousWeek() {
    setState(() {
      currentStartDate = currentStartDate.subtract(
        const Duration(days: 7),
      );
      _updateWeeklyParams();
    });
  }

  void _nextWeek() {
    setState(() {
      currentStartDate = currentStartDate.add(
        const Duration(days: 7),
      );
      _updateWeeklyParams();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadName();
    _updateWeeklyParams();
  }

  Future<void> _loadName() async {
    final name = await _storage.read(key: 'fullName');
    if (mounted) {
      setState(() {
        fullName = name ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignedPlansAsync = ref.watch(
      assignedPlansFutureProvider,
    );
    final weeklyReviewAsync = ref.watch(
      weeklyReviewProvider(_weeklyParams),
    );

    return SafeArea(
      child: Column(
        children: [
          // Header
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

          // Weekly Summary
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              0,
            ),
            child: Column(
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
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _previousWeek,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(
                      '${DateFormat('d MMM').format(_weeklyParams.startDate)} - ${DateFormat('d MMM').format(_weeklyParams.endDate)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _nextWeek,
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                weeklyReviewAsync.when(
                  loading:
                      () =>
                          const CircularProgressIndicator(),
                  error: (err, _) => Text('Error: $err'),
                  data:
                      (weekly) => Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TSS: ${weekly.totalTSS.toStringAsFixed(1)}',
                          ),
                          Text(
                            'Duration: ${weekly.completedDuration} min',
                          ),
                          Text(
                            'Avg RPE: ${weekly.averageRPE}',
                          ),
                          const SizedBox(height: 12),
                          TssBarChart(
                            tssValues:
                                weekly.days
                                    .map(
                                      (day) =>
                                          day.tss
                                              .toDouble(),
                                    )
                                    .toList(),
                          ),
                          const SizedBox(height: 12),
                          ...weekly.days.map(
                            (day) => ListTile(
                              title: Text(day.title),
                              subtitle: Text(
                                'TSS: ${day.tss} — RPE: ${day.rating}',
                              ),
                              trailing: Icon(
                                day.isCompleted
                                    ? Icons.check
                                    : Icons.schedule,
                                color:
                                    day.isCompleted
                                        ? Colors.green
                                        : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                ),
              ],
            ),
          ),

          // Plans
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
                            plan.trainingDayId == 0)
                          return;

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
                                      plan.trainingDayId!,
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
