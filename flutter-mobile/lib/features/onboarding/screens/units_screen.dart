import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:frontend/features/onboarding/screens/generate_plan_screen.dart';

class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    final selectedUnit =
        ref.watch(onboardingAnswersProvider).units;

    void _onSelect(String unit) {
      ref
          .read(onboardingAnswersProvider.notifier)
          .state = ref
          .read(onboardingAnswersProvider)
          .copyWith(units: unit);
    }

    void _onContinue() {
      if (selectedUnit == null) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const GeneratePlanScreen(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor:
            isDark
                ? Theme.of(context).scaffoldBackgroundColor
                : const Color(0xFFFFF3E0),
        title: const LinearProgressIndicator(
          value: 0.95,
          minHeight: 4,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What unit of measurement do you use?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "This helps us tailor the plan to your preferences.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              _UnitCard(
                label: 'Kilometers (km)',
                isSelected: selectedUnit == 'km',
                onTap: () => _onSelect('km'),
              ),
              const SizedBox(height: 16),
              _UnitCard(
                label: 'Miles (mi)',
                isSelected: selectedUnit == 'mi',
                onTap: () => _onSelect('mi'),
              ),
              const SizedBox(
                height: 32,
              ), // 👈 odvoji kartice od dugmeta
              ElevatedButton(
                onPressed:
                    selectedUnit != null
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

class _UnitCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _UnitCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color:
            isSelected
                ? Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1)
                : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 20,
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color:
                    isSelected
                        ? Theme.of(
                          context,
                        ).colorScheme.primary
                        : Colors.grey,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
