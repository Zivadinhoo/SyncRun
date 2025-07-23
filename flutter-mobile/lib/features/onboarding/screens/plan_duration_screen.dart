import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:go_router/go_router.dart';

class PlanDurationScreen extends ConsumerStatefulWidget {
  const PlanDurationScreen({super.key});

  @override
  ConsumerState<PlanDurationScreen> createState() =>
      _PlanDurationScreenState();
}

class _PlanDurationScreenState
    extends ConsumerState<PlanDurationScreen> {
  int? selectedWeeks;

  final List<int> weekOptions = [2, 3, 4, 6, 8, 10, 12, 16];

  void _continue() {
    if (selectedWeeks == null) return;

    ref
        .read(onboardingAnswersProvider.notifier)
        .setDurationInWeeks(selectedWeeks!);

    // ✅ Navigate to next screen
    context.push('/onboarding/units');
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text("Plan Duration"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: 6 / 8,
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
                "How many weeks do you want your plan to last?",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground
                      .withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: weekOptions.length,
                separatorBuilder:
                    (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final weeks = weekOptions[index];
                  final isSelected = selectedWeeks == weeks;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedWeeks = weeks;
                      });
                    },
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
                        "$weeks weeks",
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
                    selectedWeeks != null
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
