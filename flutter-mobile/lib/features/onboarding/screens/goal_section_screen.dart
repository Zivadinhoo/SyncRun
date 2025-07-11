import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:go_router/go_router.dart';

class GoalSectionScreen extends ConsumerWidget {
  const GoalSectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingAnswers = ref.watch(
      onboardingAnswersProvider,
    );
    final selectedGoal = onboardingAnswers.goal;
    final selectedGoalTag = onboardingAnswers.goalTag;

    void selectGoal(String title, String tag) {
      ref
          .read(onboardingAnswersProvider.notifier)
          .setGoal(title, tag);
    }

    String getNextRoute(String? tag) {
      switch (tag) {
        case 'race':
        case 'performance':
          return '/onboarding/target-distance';
        case 'beginner':
        case 'health':
        case 'postnatal':
        default:
          return '/onboarding/experience';
      }
    }

    final goalOptions = [
      {
        'emoji': '🏁',
        'title': 'I’m training for a race',
        'description':
            'You have a race coming up and want a plan that gets you ready.',
        'tag': 'race',
      },
      {
        'emoji': '🐣',
        'title': 'I’m new to running',
        'description':
            'You’re just getting started and want to build consistency.',
        'tag': 'beginner',
      },
      {
        'emoji': '⏱️',
        'title': 'I want to run faster',
        'description':
            'Improve your time for 5k, 10k, half or full marathon.',
        'tag': 'performance',
      },
      {
        'emoji': '❤️',
        'title': 'I want to stay fit',
        'description':
            'General structure and motivation to keep moving.',
        'tag': 'health',
      },
      {
        'emoji': '👶',
        'title': 'I’m returning post-baby',
        'description':
            'A gentle return to running after pregnancy.',
        'tag': 'postnatal',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text("What is your goal?"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: 1 / 7,
                minHeight: 4,
                backgroundColor: Colors.grey.shade800,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Pick a goal that suits you best',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: goalOptions.length,
                separatorBuilder:
                    (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final goal = goalOptions[index];
                  final isSelected =
                      selectedGoal == goal['title'];
                  return GoalCard(
                    emoji: goal['emoji']!,
                    title: goal['title']!,
                    description: goal['description']!,
                    selected: isSelected,
                    onTap:
                        () => selectGoal(
                          goal['title']!,
                          goal['tag']!,
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
                    selectedGoalTag == null
                        ? null
                        : () {
                          context.push(
                            getNextRoute(selectedGoalTag),
                          );
                        },
                child: const Text('Continue'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const GoalCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;
    final onSurface =
        Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              selected ? primary.withOpacity(0.1) : surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                selected ? primary : Colors.grey.shade800,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color:
                                selected
                                    ? primary
                                    : onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (selected)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(
                      color:
                          selected
                              ? primary.withOpacity(0.8)
                              : onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
