import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/ai_generated_plan_provider.dart';
import 'package:frontend/features/onboarding/providers/ai_plan_provider.dart';
import 'package:frontend/features/athlete/widgets/ai_day_card.dart';
import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class AthleteDashboardScreen extends ConsumerWidget {
  const AthleteDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backendPlanAsync = ref.watch(aiPlanProvider);
    final localPlan = ref.watch(aiGeneratedPlanProvider);

    return backendPlanAsync.when(
      data: (plan) {
        if (plan == null && localPlan == null) {
          return _buildNoPlanView(context, ref);
        }
        return _buildPlanView(
          context,
          ref,
          plan ?? localPlan!,
        );
      },
      loading:
          () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      error: (err, _) {
        if (localPlan != null) {
          return _buildPlanView(context, ref, localPlan);
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
                _buildLogoutButton(context, ref),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoPlanView(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
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
              onPressed: () {
                context.go('/onboarding/goal');
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Start onboarding"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA94D),
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            _buildLogoutButton(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanView(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> plan,
  ) {
    final weeks = plan['weeks'] as List<dynamic>?;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text("🏃 Your AI Training Plan"),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFA94D),
        foregroundColor: Colors.black,
      ),
      body:
          weeks == null || weeks.isEmpty
              ? const Center(
                child: Text("Training plan is empty."),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: weeks.length,
                itemBuilder: (context, weekIndex) {
                  final week = weeks[weekIndex];
                  final weekNumber =
                      week['week'] ?? (weekIndex + 1);
                  final days =
                      week['days'] as List<dynamic>;

                  return Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Week $weekNumber',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...days.map((day) {
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(
                                vertical: 6,
                              ),
                          child: AiDayCard(
                            dayName: day['day'],
                            type: day['type'],
                            distance: day['distance'],
                            pace: day['pace'],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: _buildLogoutButton(context, ref),
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    WidgetRef ref,
  ) {
    return ElevatedButton.icon(
      onPressed: () async {
        final auth = ref.read(authServiceProvider);
        await auth.logout();
        context.go('/login');
      },
      icon: const Icon(Icons.logout),
      label: const Text("Logout"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }
}
