import 'package:flutter/material.dart';
import 'package:frontend/features/onboarding/widgets/goal_option.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() =>
      _GoalSelectionScreenState();
}

class _GoalSelectionScreenState
    extends State<GoalSelectionScreen> {
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

  void _onNext() {
    if (selectedGoal != null) {
      // TODO: Save selected goal and go to next screen
      debugPrint('Selected goal: $selectedGoal');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            isDark
                ? Theme.of(context).scaffoldBackgroundColor
                : const Color(0xFFFFF3E0),
        title: const Text("What’s your goal?"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Choose your primary running goal:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return GoalOption(
                    emoji: goal['emoji']!,
                    title: goal['title']!,
                    isSelected:
                        selectedGoal == goal['title'],
                    onTap: () {
                      setState(() {
                        selectedGoal = goal['title'];
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed:
                  selectedGoal != null ? _onNext : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
