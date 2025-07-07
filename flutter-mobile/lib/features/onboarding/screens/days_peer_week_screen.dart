import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:frontend/features/onboarding/screens/prefered_days_screen.dart';

class DaysPerWeekScreen extends ConsumerStatefulWidget {
  const DaysPerWeekScreen({super.key});

  @override
  ConsumerState<DaysPerWeekScreen> createState() =>
      _DaysPerWeekScreenState();
}

class _DaysPerWeekScreenState
    extends ConsumerState<DaysPerWeekScreen> {
  int? selectedDays;
  final List<int> options = [2, 3, 4, 5, 6];

  void _onContinue() {
    if (selectedDays == null) return;

    ref.read(onboardingAnswersProvider.notifier).state = ref
        .read(onboardingAnswersProvider)
        .copyWith(weeklyRuns: selectedDays);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => PreferredDaysScreen(
              requiredDays: selectedDays!,
            ),
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
          value: 0.83,
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
                "How many days per week would you like to run?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Choose how many times per week you want to train. Don’t overcommit – recovery matters!",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ...options.map((day) {
                final isSelected = selectedDays == day;
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: GestureDetector(
                    onTap:
                        () => setState(
                          () => selectedDays = day,
                        ),
                    child: Card(
                      elevation: isSelected ? 2 : 0,
                      color:
                          isSelected
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1)
                              : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.primary
                                  : Colors.grey.shade300,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color:
                                  isSelected
                                      ? Theme.of(
                                        context,
                                      ).colorScheme.primary
                                      : Colors.grey,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              "$day Days",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primary
                                        : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    selectedDays != null
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
