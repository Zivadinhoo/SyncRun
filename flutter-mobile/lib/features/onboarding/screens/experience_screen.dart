import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:frontend/features/onboarding/screens/days_peer_week_screen.dart';

class ExperienceScreen extends ConsumerStatefulWidget {
  const ExperienceScreen({super.key});

  @override
  ConsumerState<ExperienceScreen> createState() =>
      _ExperienceScreenState();
}

class _ExperienceScreenState
    extends ConsumerState<ExperienceScreen> {
  String? selectedExperience;

  final List<Map<String, String>> experienceLevels = [
    {
      'emoji': '🐣',
      'title': 'Beginner',
      'subtitle': 'You can jog 5 km in under 60 minutes.',
    },
    {
      'emoji': '🏃',
      'title': 'Intermediate',
      'subtitle':
          'You run 5+ km regularly without a strict plan.',
    },
    {
      'emoji': '🏁',
      'title': 'Advanced',
      'subtitle':
          'You do intervals and longer runs (10+ km).',
    },
    {
      'emoji': '🏅',
      'title': 'Elite',
      'subtitle':
          'You follow structured plans for 21 km or more.',
    },
  ];

  void _onExperienceSelected(String title) {
    setState(() => selectedExperience = title);
  }

  void _onContinue() {
    if (selectedExperience == null) return;

    ref.read(onboardingAnswersProvider.notifier).state = ref
        .read(onboardingAnswersProvider)
        .copyWith(currentPb: selectedExperience);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DaysPerWeekScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          value: 0.4,
          minHeight: 4,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "How would you rate your running experience?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Pick the level that best describes you. You can adjust this later.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ...experienceLevels.map((level) {
                final isSelected =
                    selectedExperience == level['title'];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: GestureDetector(
                    onTap:
                        () => _onExperienceSelected(
                          level['title']!,
                        ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFFFFF3E0)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        border: Border.all(
                          color:
                              isSelected
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.primary
                                  : Colors.grey.shade300,
                          width: 1.4,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            level['emoji']!,
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level['title']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
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
                                const SizedBox(height: 4),
                                Text(
                                  level['subtitle']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Padding(
                              padding:
                                  const EdgeInsets.only(
                                    top: 4,
                                  ),
                              child: Icon(
                                Icons.check_circle,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    selectedExperience != null
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
