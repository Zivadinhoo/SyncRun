import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/athelete/providers/weekly_review_provider.dart';
import 'package:frontend/features/athelete/widgets/weekly_tss_bar_chart.dart';
import 'package:frontend/features/athelete/widgets/training_plan_card.dart';
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
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildWeeklySummary(weeklyReviewAsync),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 8)),
          _buildAssignedPlans(assignedPlansAsync),
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
                      tssValues:
                          weekly.days
                              .map((d) {
                                final value = d.tss;
                                if (value is num)
                                  return value.toDouble();
                                return 0.0;
                              })
                              .toList()
                              .cast<double>(),
                    ),
                  ],
                ),
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
