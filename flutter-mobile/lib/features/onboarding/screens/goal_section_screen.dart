import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:go_router/go_router.dart';

class GoalSectionScreen extends ConsumerWidget {
  const GoalSectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoal =
        ref.watch(onboardingAnswersProvider).goal;

    void selectGoal(String goal) {
      ref
          .read(onboardingAnswersProvider.notifier)
          .setGoal(goal);
    }

    final goalOptions = [
      {
        'emoji': '🏁',
        'title': 'Race',
        'description':
            'Booked a running race and want to train?',
      },
      {
        'emoji': '🏔️',
        'title': 'Run a specific distance',
        'description':
            'Choose your distance, from 5k to an ultramarathon',
      },
      {
        'emoji': '🐣',
        'title': 'Run a first 5k',
        'description':
            'Perfect for beginners starting their journey',
      },
      {
        'emoji': '🌬️',
        'title': '5k improvement plan',
        'description':
            'Want to run a faster or smoother 5k?',
      },
      {
        'emoji': '❤️',
        'title': 'General training',
        'description':
            'Maintain fitness without targeting a specific goal',
      },
      {
        'emoji': '🌱',
        'title': 'Parkrun improvement plan',
        'description':
            'Improve your weekend 5k performance',
      },
      {
        'emoji': '👶',
        'title': 'Postnatal plan',
        'description':
            'Designed for new mothers getting back into running',
      },
      {
        'emoji': '⏱️',
        'title': 'Time goal',
        'description':
            'Train for a specific time like sub-2h half',
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
            onPressed:
                () =>
                    context
                        .pop(), // ili context.go('/') ako baš mora
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
                    onTap: () => selectGoal(goal['title']!),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    selectedGoal == null
                        ? null
                        : () {
                          final next =
                              (selectedGoal ==
                                      'Run a specific distance')
                                  ? '/onboarding/target-time'
                                  : '/onboarding/experience';
                          context.push(
                            next,
                          ); // << izmenjeno
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
          color: selected ? primary : surface,
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
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(
                      color:
                          selected
                              ? Colors.white
                              : onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(
                      color:
                          selected
                              ? Colors.white70
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
