import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:frontend/features/onboarding/screens/units_screen.dart';

class StartDateScreen extends ConsumerStatefulWidget {
  const StartDateScreen({super.key});

  @override
  ConsumerState<StartDateScreen> createState() =>
      _StartDateScreenState();
}

class _StartDateScreenState
    extends ConsumerState<StartDateScreen> {
  DateTime? selectedDate;

  void _pickDate(BuildContext context) async {
    final today = DateTime.now();
    final initialDate = selectedDate ?? today;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);

      // Save to provider
      ref
          .read(onboardingAnswersProvider.notifier)
          .state = ref
          .read(onboardingAnswersProvider)
          .copyWith(startDate: picked);
    }
  }

  void _onContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UnitsScreen(),
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
          value: 0.9,
          minHeight: 4,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "When would you like to start your plan?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Choose a date that suits your schedule. You can start today or any time within the next year.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.primary,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate != null
                            ? DateFormat.yMMMMd().format(
                              selectedDate!,
                            )
                            : "Select a date",
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              selectedDate != null
                                  ? Colors.black
                                  : Colors.grey,
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed:
                  selectedDate != null ? _onContinue : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
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
