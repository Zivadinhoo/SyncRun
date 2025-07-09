import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:go_router/go_router.dart';

class TargetTimeScreen extends ConsumerStatefulWidget {
  const TargetTimeScreen({super.key});

  @override
  ConsumerState<TargetTimeScreen> createState() =>
      _TargetTimeScreenState();
}

class _TargetTimeScreenState
    extends ConsumerState<TargetTimeScreen> {
  final _hoursController = TextEditingController();
  final _minutesController = TextEditingController();

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    final hoursText = _hoursController.text.trim();
    final minutesText = _minutesController.text.trim();

    if (hoursText.isEmpty || minutesText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter both hours and minutes",
          ),
        ),
      );
      return;
    }

    final targetTime = "${hoursText}h ${minutesText}m";
    ref
        .read(onboardingAnswersProvider.notifier)
        .setTargetTime(targetTime);

    context.go('/onboarding/experience');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Target Time"),
        centerTitle: true,
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              "For what time do you want to finish the race?",
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Hours',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _minutesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minutes',
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAndContinue,
                child: const Text("Continue"),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
