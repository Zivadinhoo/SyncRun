import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:frontend/features/onboarding/screens/noftication_screen.dart';

class PreferredDaysScreen extends ConsumerStatefulWidget {
  final int requiredDays;

  const PreferredDaysScreen({
    super.key,
    required this.requiredDays,
  });

  @override
  ConsumerState<PreferredDaysScreen> createState() =>
      _PreferredDaysScreenState();
}

class _PreferredDaysScreenState
    extends ConsumerState<PreferredDaysScreen> {
  final Map<String, bool> selectedDays = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  bool get isValidSelection =>
      selectedDays.values.where((v) => v).length >=
      widget.requiredDays;

  void _onToggle(String day) {
    setState(() {
      selectedDays[day] = !(selectedDays[day] ?? false);
    });
  }

  void _onContinue() {
    final chosenDays =
        selectedDays.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList();

    ref.read(onboardingAnswersProvider.notifier).state = ref
        .read(onboardingAnswersProvider)
        .copyWith(
          weeklyRuns: widget.requiredDays,
          preferredDays: chosenDays,
        );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isDark
                ? theme.scaffoldBackgroundColor
                : const Color(0xFFFFF3E0),
        title: const Text(
          '',
          style: TextStyle(color: Colors.transparent),
        ),
        leading: const BackButton(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 0.80,
            minHeight: 4,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Which days of the week are you free to run on?",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Select at least ${widget.requiredDays} days spread across the week to help us create your ideal plan.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: selectedDays.length,
                separatorBuilder:
                    (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final day = selectedDays.keys.elementAt(
                    index,
                  );
                  final isSelected =
                      selectedDays[day] ?? false;

                  return GestureDetector(
                    onTap: () => _onToggle(day),
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        color:
                            isSelected
                                ? theme.colorScheme.primary
                                    .withOpacity(0.1)
                                : theme.cardColor,
                        border: Border.all(
                          color:
                              isSelected
                                  ? theme
                                      .colorScheme
                                      .primary
                                  : Colors.grey.shade300,
                          width: 1.4,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons
                                    .radio_button_unchecked,
                            color:
                                isSelected
                                    ? theme
                                        .colorScheme
                                        .primary
                                    : Colors.grey,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            day,
                            style:
                                theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (!isValidSelection)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Center(
                  child: Text(
                    "Please select at least ${widget.requiredDays} days.",
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  isValidSelection ? _onContinue : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
