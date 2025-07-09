import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:go_router/go_router.dart';

class ExperienceScreen extends ConsumerStatefulWidget {
  const ExperienceScreen({super.key});

  @override
  ConsumerState<ExperienceScreen> createState() =>
      _ExperienceScreenState();
}

class _ExperienceScreenState
    extends ConsumerState<ExperienceScreen> {
  String? selectedExperience;

  final List<_ExperienceOption> options = [
    _ExperienceOption(
      title: 'Beginner 🐣',
      description:
          'You can run 5km without stopping, under 60 minutes',
      value: 'Beginner',
    ),
    _ExperienceOption(
      title: 'Intermediate 🏃‍♂️',
      description:
          'You run at least 5km regularly, but without a structured plan',
      value: 'Intermediate',
    ),
    _ExperienceOption(
      title: 'Advanced 💪',
      description:
          'You run at least 10km and include structured training (e.g. intervals)',
      value: 'Advanced',
    ),
    _ExperienceOption(
      title: 'Elite 🏆',
      description:
          'You run half marathons or longer and follow structured training',
      value: 'Elite',
    ),
  ];

  void _select(String value) {
    setState(() => selectedExperience = value);
  }

  void _continue() {
    if (selectedExperience != null) {
      ref
          .read(onboardingAnswersProvider.notifier)
          .setExperience(selectedExperience!);
      context.push('/onboarding/days-per-week');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding/goal'),
        ),

        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text("Running Expirience"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: 2 / 7,
                minHeight: 4,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation(
                  colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "How would you rate your running ability?",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground
                      .withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: options.length,
                separatorBuilder:
                    (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected =
                      selectedExperience == option.value;
                  return GestureDetector(
                    onTap: () => _select(option.value),
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? colorScheme.primary
                                : Theme.of(
                                  context,
                                ).cardColor,
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        border: Border.all(
                          color:
                              isSelected
                                  ? colorScheme.primary
                                  : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.title,
                            style: textTheme.bodyLarge
                                ?.copyWith(
                                  fontWeight:
                                      FontWeight.w600,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : colorScheme
                                              .onSurface,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            option.description,
                            style: textTheme.bodyMedium
                                ?.copyWith(
                                  color:
                                      isSelected
                                          ? Colors.white
                                              .withOpacity(
                                                0.9,
                                              )
                                          : colorScheme
                                              .onSurface
                                              .withOpacity(
                                                0.7,
                                              ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    selectedExperience == null
                        ? null
                        : _continue,
                child: const Text("Continue"),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ExperienceOption {
  final String title;
  final String description;
  final String value;

  const _ExperienceOption({
    required this.title,
    required this.description,
    required this.value,
  });
}
