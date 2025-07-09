import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:go_router/go_router.dart';

class PreferredDaysScreen extends ConsumerStatefulWidget {
  const PreferredDaysScreen({super.key});

  @override
  ConsumerState<PreferredDaysScreen> createState() =>
      _PreferredDaysScreenState();
}

class _PreferredDaysScreenState
    extends ConsumerState<PreferredDaysScreen> {
  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final Set<String> selectedDays = {};

  void toggleDay(String day) {
    setState(() {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
      } else {
        selectedDays.add(day);
      }
    });
  }

  void _continue() {
    final requiredDays =
        ref.read(onboardingAnswersProvider).daysPerWeek;
    if (selectedDays.length != requiredDays) return;
    ref
        .read(onboardingAnswersProvider.notifier)
        .setPreferredDays(selectedDays.toList());
    context.push('/onboarding/start-date');
  }

  @override
  Widget build(BuildContext context) {
    final requiredDays =
        ref.watch(onboardingAnswersProvider).daysPerWeek;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text("Preferred Days"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: 4 / 7,
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
                "Please select $requiredDays days you prefer to train",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground
                      .withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: weekdays.length,
                separatorBuilder:
                    (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final day = weekdays[index];
                  final isSelected = selectedDays.contains(
                    day,
                  );
                  return GestureDetector(
                    onTap: () => toggleDay(day),
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
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:
                              isSelected
                                  ? Colors.white
                                  : colorScheme.onSurface,
                        ),
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
                    selectedDays.length == requiredDays
                        ? _continue
                        : null,
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
