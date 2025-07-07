import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/screens/experience_screen.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';

class GoalSelectionScreen extends ConsumerStatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  ConsumerState<GoalSelectionScreen> createState() =>
      _GoalSelectionScreenState();
}

class _GoalSelectionScreenState
    extends ConsumerState<GoalSelectionScreen> {
  String? selectedGoal;

  final List<Map<String, String>> goals = [
    {'emoji': '🐣', 'title': 'Run my first 5K'},
    {'emoji': '🎯', 'title': 'Run my first 10K'},
    {'emoji': '🛣️', 'title': 'Run a half marathon'},
    {'emoji': '🏔️', 'title': 'Run a full marathon'},
    {'emoji': '⚡', 'title': 'Get faster'},
    {'emoji': '⚖️', 'title': 'Lose weight'},
    {'emoji': '😄', 'title': 'Run for fun'},
  ];

  void _onGoalSelected(String goal) {
    setState(() => selectedGoal = goal);
  }

  void _onContinue() {
    if (selectedGoal == null) return;

    ref.read(onboardingAnswersProvider.notifier).state = ref
        .read(onboardingAnswersProvider)
        .copyWith(goal: selectedGoal);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ExperienceScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor:
            isDark
                ? Theme.of(context).scaffoldBackgroundColor
                : const Color(0xFFFFF3E0),
        title: LinearProgressIndicator(
          value: 0.0, // 👈 start progress bar at 10%
          minHeight: 4,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What’s your goal?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Choose your primary running goal:",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: goals.length,
                  separatorBuilder:
                      (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    final isSelected =
                        selectedGoal == goal['title'];

                    return GestureDetector(
                      onTap:
                          () => _onGoalSelected(
                            goal['title']!,
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFFFFF3E0)
                                  : Colors.white,
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected
                                    ? Theme.of(
                                      context,
                                    ).colorScheme.primary
                                    : Colors.grey.shade300,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  goal['emoji']!,
                                  style: const TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  goal['title']!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight.w500,
                                    color:
                                        isSelected
                                            ? Theme.of(
                                                  context,
                                                )
                                                .colorScheme
                                                .primary
                                            : Colors
                                                .black87,
                                  ),
                                ),
                              ],
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    selectedGoal != null
                        ? _onContinue
                        : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text("Continue"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
