import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/features/athelete/providers/weekly_review_provider.dart';
import 'package:frontend/features/athelete/widgets/weekly_tss_bar_chart.dart';
import 'package:frontend/features/athelete/widgets/training_plan_card.dart';
import 'package:frontend/features/athelete/providers/assigned_plans_provider.dart';
import 'package:frontend/features/athelete/providers/training_days_providert.dart';
import 'package:intl/intl.dart';
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
  int? athleteId;
  int? _activePlanId;
  DateTime currentStartDate = _getStartOfWeek(
    DateTime.now(),
  );
  WeeklyReviewParams? _weeklyParams; // ✅ FIX

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
      final data = jsonDecode(response.body);
      setState(() {
        athleteId = data['id'];
      });
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
      assignedPlansFutureProvider,
    );
    final activePlanIdAsync = ref.watch(
      activePlanIdProvider,
    );

    activePlanIdAsync.whenData((activePlanId) {
      if (_activePlanId != activePlanId &&
          activePlanId != null) {
        _activePlanId = activePlanId;
        _updateWeeklyParams(activePlanId);
      }
    });

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
          SliverToBoxAdapter(child: SizedBox(height: 8)),
          activePlanIdAsync.when(
            loading:
                () => const SliverToBoxAdapter(
                  child: SizedBox(),
                ),
            error:
                (err, _) => const SliverToBoxAdapter(
                  child: SizedBox(),
                ),
            data: (activePlanId) {
              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildActivePlanNotice(
                      assignedPlansAsync,
                      activePlanId,
                    ),
                    if (activePlanId != null)
                      _buildTrainingDays(activePlanId),
                  ],
                ),
              );
            },
          ),
          activePlanIdAsync.when(
            loading:
                () => const SliverToBoxAdapter(
                  child: SizedBox(),
                ),
            error:
                (err, _) => const SliverToBoxAdapter(
                  child: SizedBox(),
                ),
            data: (activePlanId) {
              if (activePlanId == null) {
                return _buildAssignedPlans(
                  assignedPlansAsync,
                );
              } else {
                return const SliverToBoxAdapter(
                  child: SizedBox(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary(AsyncValue weeklyReviewAsync) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
          const SizedBox(height: 8),
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
        ],
      ),
    );
  }

  Widget _buildActivePlanNotice(
    AsyncValue assignedPlansAsync,
    int? activePlanId,
  ) {
    return assignedPlansAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (err, _) => const SizedBox.shrink(),
      data: (plans) {
        if (activePlanId == null)
          return const SizedBox.shrink();
        final activePlan = plans.firstWhere(
          (plan) => plan.id == activePlanId,
          orElse: () => plans.first,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🔥 Active Plan: ${activePlan.trainingPlan.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '🗓 Assigned at: ${DateFormat.yMMMEd().format(activePlan.assignedAt)}',
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrainingDays(int activePlanId) {
    final trainingDaysAsync = ref.watch(
      trainingDaysProvider(activePlanId),
    );
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: trainingDaysAsync.when(
          loading:
              () => const Center(
                child: CircularProgressIndicator(),
              ),
          error:
              (err, _) => Text(
                'Failed to load training days: $err',
              ),
          data: (days) {
            if (days.isEmpty)
              return const Text('No training days found.');
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
                  final formatted = DateFormat(
                    'EEEE, d MMM',
                  ).format(day.date);
                  return Card(
                    child: ListTile(
                      title: Text(formatted),
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
                      leading: const Icon(
                        Icons.directions_run,
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
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
        final validPlans =
            plans
                .where((p) => p.trainingPlan != null)
                .toList();
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
                await ref.read(setActivePlanProvider)(
                  plan.id,
                );
                if (plan.trainingDayId == null ||
                    plan.trainingDayId == 0)
                  return;
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
                    assignedPlansFutureProvider,
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
