import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:go_router/go_router.dart';

class DaysPerWeekScreen extends ConsumerStatefulWidget {
  const DaysPerWeekScreen({super.key});

  @override
  ConsumerState<DaysPerWeekScreen> createState() =>
      _DaysPerWeekScreenState();
}

class _DaysPerWeekScreenState
    extends ConsumerState<DaysPerWeekScreen> {
  int? selectedDays;

  void _selectDays(int days) {
    setState(() => selectedDays = days);
  }

  void _continue() {
    if (selectedDays != null) {
      ref
          .read(onboardingAnswersProvider.notifier)
          .setDaysPerWeek(selectedDays!);
      context.push(
        '/onboarding/preferred-days',
      ); // changed from go to push
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
          onPressed: () => context.pop(),
        ),
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text("Training Frequency"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: 3 / 7, // 👈 ažurirano
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
                "How many days per week would you like to train?",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground
                      .withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: 6,
                separatorBuilder:
                    (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final day = index + 1;
                  final isSelected = selectedDays == day;
                  return DayOptionCard(
                    day: day,
                    selected: isSelected,
                    onTap: () => _selectDays(day),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    selectedDays == null ? null : _continue,
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

class DayOptionCard extends StatelessWidget {
  final int day;
  final bool selected;
  final VoidCallback onTap;

  const DayOptionCard({
    super.key,
    required this.day,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              selected
                  ? colorScheme.primary
                  : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                selected
                    ? colorScheme.primary
                    : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Text(
          '$day day${day > 1 ? 's' : ''} per week',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : onSurface,
          ),
        ),
      ),
    );
  }
}
