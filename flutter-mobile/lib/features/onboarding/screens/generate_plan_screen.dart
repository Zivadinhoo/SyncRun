import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';

class GeneratePlanScreen extends ConsumerWidget {
  const GeneratePlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answers = ref.watch(onboardingAnswersProvider);
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor:
            isDark
                ? Theme.of(context).scaffoldBackgroundColor
                : const Color(0xFFFFF3E0),
        title: LinearProgressIndicator(
          value: 1.0,
          minHeight: 4,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "You're ready to go!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Here's a summary of your selections. Tap the button below to generate your personalized plan.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),

              _summaryCard("🎯 Goal", answers.goal),
              _summaryCard(
                "⏱️ Target Time",
                answers.targetTime,
              ),
              _summaryCard(
                "📈 Experience (PB)",
                answers.currentPb,
              ),
              _summaryCard(
                "📅 Days per week",
                answers.weeklyRuns?.toString(),
              ),
              _summaryCard(
                "🔔 Notifications",
                answers.notificationsEnabled == true
                    ? "Enabled"
                    : "Disabled",
              ),
              _summaryCard(
                "📆 Start Date",
                answers.startDate != null
                    ? DateFormat.yMMMMd().format(
                      answers.startDate!,
                    )
                    : null,
              ),
              _summaryCard(
                "📏 Units",
                answers.units?.toUpperCase(),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Plan is being generated...",
                      ),
                    ),
                  );

                  // TODO: Pozovi API za generisanje plana
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text("Generate My Plan"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(String label, String? value) {
    if (value == null) return const SizedBox.shrink();

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
