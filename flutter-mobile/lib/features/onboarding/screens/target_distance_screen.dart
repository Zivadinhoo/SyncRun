import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:go_router/go_router.dart';

class TargetDistanceScreen extends ConsumerStatefulWidget {
  const TargetDistanceScreen({super.key});

  @override
  ConsumerState<TargetDistanceScreen> createState() =>
      _TargetDistanceScreenState();
}

class _TargetDistanceScreenState
    extends ConsumerState<TargetDistanceScreen> {
  String? selectedDistance;
  final TextEditingController _targetTimeController =
      TextEditingController();

  final List<String> distanceOptions = [
    '5K',
    '10K',
    'Half Marathon',
    'Marathon',
    'Ultramarathon',
  ];

  @override
  void dispose() {
    _targetTimeController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final targetTime = _targetTimeController.text.trim();

    ref
        .read(onboardingAnswersProvider.notifier)
        .setTargetDistance(selectedDistance!);
    if (targetTime.isNotEmpty) {
      ref
          .read(onboardingAnswersProvider.notifier)
          .setTargetTime(targetTime);
    }

    context.push('/onboarding/experience');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Race Details'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: 2 / 7,
                minHeight: 4,
                backgroundColor: Colors.grey.shade800,
                valueColor: AlwaysStoppedAnimation(
                  theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Which distance are you targeting?',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedDistance,
              items:
                  distanceOptions
                      .map(
                        (distance) => DropdownMenuItem(
                          value: distance,
                          child: Text(distance),
                        ),
                      )
                      .toList(),
              onChanged:
                  (value) => setState(
                    () => selectedDistance = value,
                  ),
              decoration: const InputDecoration(
                labelText: 'Select distance',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Do you have a time goal? (optional)',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _targetTimeController,
              decoration: const InputDecoration(
                hintText:
                    'e.g. Sub 50 minutes, 3:45 marathon',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    selectedDistance == null
                        ? null
                        : _onContinue,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
