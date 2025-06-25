import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/models/assigned_plan.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/features/athelete/providers/weekly_review_provider.dart';
import 'package:frontend/features/athelete/widgets/weekly_tss_bar_chart.dart';
import 'package:frontend/features/athelete/widgets/training_plan_card.dart';
import 'package:frontend/features/athelete/providers/assigned_plans_provider.dart'
    as assigned;
import 'package:frontend/features/athelete/providers/active_plan_provider.dart'
    as active;
import 'package:frontend/features/athelete/providers/training_days_providert.dart';
import 'package:intl/intl.dart';
import 'training_day_screen.dart';
import '../widgets/active_plan_card.dart';

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
  int? athleteId;
  int? _activePlanId;
  DateTime currentStartDate = _getStartOfWeek(
    DateTime.now(),
  );
  WeeklyReviewParams? _weeklyParams;

  static DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  @override
  void initState() {
    super.initState();
    _loadUserAndParams();
    _loadName();
  }

  Future<void> _loadUserAndParams() async {
    final token = await _storage.read(key: 'accessToken');
    if (token == null) return;

    final response = await http.get(
      Uri.parse('http://192.168.0.45:3001/users/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        final planId = data['activeAssignedPlanId'];
        if (planId != null) {
          ref.read(active.setActivePlanProvider)(planId);
        }
        setState(() {
          athleteId = data['id'];
        });
      } catch (e) {
        print('❌ JSON PARSE FAIL: $e');
      }
    } else {
      print('❌ Failed to fetch user');
    }
  }

  void _loadName() async {
    final name = await _storage.read(key: 'fullName');
    if (mounted) {
      setState(() {
        fullName = name ?? '';
      });
    }
  }

  void _updateWeeklyParams(int activePlanId) {
    final startDate = currentStartDate;
    final endDate = startDate.add(const Duration(days: 6));
    setState(() {
      _weeklyParams = WeeklyReviewParams(
        assignedPlanId: activePlanId,
        startDate: startDate,
        endDate: endDate,
      );
    });
  }

  void _previousWeek() {
    setState(() {
      currentStartDate = currentStartDate.subtract(
        const Duration(days: 7),
      );
      if (_activePlanId != null) {
        _updateWeeklyParams(_activePlanId!);
      }
    });
  }

  void _nextWeek() {
    setState(() {
      currentStartDate = currentStartDate.add(
        const Duration(days: 7),
      );
      if (_activePlanId != null) {
        _updateWeeklyParams(_activePlanId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final assignedPlansAsync = ref.watch(
      assigned.assignedPlansFutureProvider,
    );
    final activePlanId = ref.watch(
      active.activePlanIdProvider,
    );

    if (_activePlanId != activePlanId &&
        activePlanId != null) {
      _activePlanId = activePlanId;
      _updateWeeklyParams(activePlanId);
    }

    final weeklyReviewAsync =
        (_weeklyParams != null)
            ? ref.watch(
              weeklyReviewProvider(_weeklyParams!),
            )
            : const AsyncValue.loading();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildWeeklySummary(weeklyReviewAsync),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(height: 8),
          ),
          if (activePlanId != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: _buildTrainingDays(activePlanId),
              ),
            )
          else
            _buildAssignedPlans(assignedPlansAsync),
        ],
      ),
    );
  }

  Widget _buildTrainingDays(int activePlanId) {
    final trainingDaysAsync = ref.watch(
      trainingDaysProvider(activePlanId),
    );

    return trainingDaysAsync.when(
      loading:
          () => const Center(
            child: CircularProgressIndicator(),
          ),
      error:
          (err, _) =>
              Text('Failed to load training days: $err'),
      data: (days) {
        if (days.isEmpty) {
          return const Text('No training days found.');
        }

        days.sort((a, b) => a.date.compareTo(b.date));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              '🏃 Training Days',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...days.map((day) {
              return Card(
                child: ListTile(
                  title: Text(
                    DateFormat(
                      'EEEE, d MMM',
                    ).format(day.date),
                  ),
                  subtitle: Text(
                    day.description.isNotEmpty
                        ? day.description
                        : 'No description',
                  ),
                  trailing: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text('⏱ ${day.duration} min'),
                      if (day.tss != null)
                        Text(
                          'TSS: ${day.tss!.toStringAsFixed(1)}',
                        ),
                    ],
                  ),
                  leading: const Icon(Icons.directions_run),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildWeeklySummary(AsyncValue weeklyReviewAsync) {
    final activePlanId = ref.watch(
      active.activePlanIdProvider,
    );
    final assignedPlansAsync = ref.watch(
      assigned.assignedPlansFutureProvider,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart, size: 20),
              SizedBox(width: 6),
              Text(
                "Weekly Summary",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
                _weeklyParams != null
                    ? '${DateFormat('d MMM').format(_weeklyParams!.startDate)} - ${DateFormat('d MMM').format(_weeklyParams!.endDate)}'
                    : '',
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
          const SizedBox(height: 4),
          weeklyReviewAsync.when(
            loading:
                () => const CircularProgressIndicator(),
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
                    Text('Avg RPE: ${weekly.averageRPE}'),
                    const SizedBox(height: 12),
                    TssBarChart(
                      tssValues: List<double>.from(
                        weekly.days.map(
                          (d) => (d.tss ?? 0).toDouble(),
                        ),
                      ),
                    ),
                  ],
                ),
          ),
          const SizedBox(height: 12),
          if (activePlanId != null)
            assignedPlansAsync.when(
              loading:
                  () => const CircularProgressIndicator(),
              error:
                  (err, _) =>
                      Text('Error loading plan: $err'),
              data: (rawPlans) {
                final List<AssignedPlan> plans =
                    List<AssignedPlan>.from(rawPlans);
                final activePlan = plans.firstWhere(
                  (p) => p.id == activePlanId,
                  orElse: () => plans.first,
                );
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.flag,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Active Plan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(activePlan.trainingPlan.name),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Assigned: ${DateFormat.yMMMEd().format(activePlan.assignedAt)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAssignedPlans(
    AsyncValue assignedPlansAsync,
  ) {
    return assignedPlansAsync.when(
      loading:
          () => const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      error:
          (err, _) => SliverToBoxAdapter(
            child: Center(child: Text('Error: $err')),
          ),
      data: (plans) {
        final Map<int, dynamic> uniquePlansMap = {};

        for (var plan in plans) {
          if (plan.trainingPlan != null) {
            uniquePlansMap[plan.id] = plan;
          }
        }

        final validPlans = uniquePlansMap.values.toList();

        if (validPlans.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text(
                'No assigned training plans yet.',
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((
            context,
            index,
          ) {
            final plan = validPlans[index];
            return TrainingPlanCard(
              plan: plan,
              onTap: () async {
                ref.read(active.setActivePlanProvider)(
                  plan.id,
                );
                if (plan.trainingDayId == null ||
                    plan.trainingDayId == 0) {
                  return;
                }
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => TrainingDayScreen(
                          planName: plan.trainingPlan.name,
                          planDescription:
                              plan.trainingPlan.description,
                          assignedAt: plan.assignedAt,
                          isCompleted: plan.isCompleted,
                          assignedPlanId: plan.id,
                          trainingDayId:
                              plan.trainingDayId!,
                        ),
                  ),
                );
                if (result == true) {
                  ref.invalidate(
                    assigned.assignedPlansFutureProvider,
                  );
                }
              },
            );
          }, childCount: validPlans.length),
        );
      },
    );
  }
}
