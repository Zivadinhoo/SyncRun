import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/athlete/widgets/weeek_section_switcher.dart';
import 'package:frontend/features/athlete/widgets/week_progress_widget.dart';
import 'package:frontend/features/models/ai_training_plan.dart';
import 'package:frontend/features/athlete/widgets/ai_day_card.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/onboarding/providers/ai_generated_plan_provider.dart';
import 'package:frontend/features/onboarding/providers/ai_plan_provider.dart';

final selectedWeekIndexProvider = StateProvider<int>(
  (ref) => 0,
);

class AthleteDashboardScreen extends ConsumerWidget {
  const AthleteDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backendPlanAsync = ref.watch(aiPlanProvider);
    final localPlan = ref.watch(aiGeneratedPlanProvider);

    return backendPlanAsync.when(
      data: (plan) {
        if (plan == null && localPlan == null) {
          return _buildNoPlanView(context);
        }

        if (plan != null) {
          print("✅ Plan loaded from backend: ${plan.name}");
          print("✅ Weeks count: ${plan.weeks.length}");
          return _buildPlanViewFromModel(
            context,
            ref,
            plan,
          );
        }

        if (localPlan != null) {
          print("📋 Using localPlan: ${localPlan.name}");
          return _buildPlanViewFromModel(
            context,
            ref,
            localPlan,
          );
        }

        return _buildNoPlanView(context);
      },
      loading:
          () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      error: (err, _) {
        if (localPlan != null) {
          return _buildPlanViewFromModel(
            context,
            ref,
            localPlan,
          );
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "❌ Failed to load your plan.\n$err",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text("Go back to login"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoPlanView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "❌ You don’t have an AI plan yet.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed:
                  () => context.go('/onboarding/goal'),
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Start onboarding"),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanViewFromModel(
    BuildContext context,
    WidgetRef ref,
    AiTrainingPlan plan,
  ) {
    return _renderPlanUi(context, ref, plan.weeks);
  }

  Widget _renderPlanUi(
    BuildContext context,
    WidgetRef ref,
    List<TrainingWeek> weeks,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    if (weeks.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("Training plan is empty."),
        ),
      );
    }

    final selectedWeekIndex = ref.watch(
      selectedWeekIndexProvider,
    );
    final week = weeks[selectedWeekIndex];
    final weekNumber = week.week;
    final total = week.days.length;
    final completed =
        week.days
            .where((d) => d.status == 'completed')
            .length;

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("🏃 Your AI Training Plan"),
        centerTitle: true,
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: WeekSectionSwitcher(
              currentWeek: weekNumber,
              totalWeeks: weeks.length,
              onPrevious: () {
                if (selectedWeekIndex > 0) {
                  ref
                      .read(
                        selectedWeekIndexProvider.notifier,
                      )
                      .state--;
                }
              },
              onNext: () {
                if (selectedWeekIndex < weeks.length - 1) {
                  ref
                      .read(
                        selectedWeekIndexProvider.notifier,
                      )
                      .state++;
                }
              },
            ),
          ),
          WeeklyProgressWidget(
            completed: completed,
            total: total,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: week.days.length,
              itemBuilder: (context, index) {
                final day = week.days[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  child: InkWell(
                    onTap:
                        () => context.push(
                          '/training-day/${day.id}',
                        ),
                    child: AiDayCard(
                      dayName: day.day,
                      type: day.type,
                      distance: day.distance,
                      pace: day.pace ?? '',
                      status: day.status,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
