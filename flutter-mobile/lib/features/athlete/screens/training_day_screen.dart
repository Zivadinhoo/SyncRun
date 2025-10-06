import 'package:flutter/material.dart';
import 'package:frontend/features/athlete/services/training_day_service.dart';
import 'package:frontend/features/models/training_day.dart';

class TrainingDayScreen extends StatefulWidget {
  final int trainingDayId;

  const TrainingDayScreen({
    super.key,
    required this.trainingDayId,
  });

  @override
  State<TrainingDayScreen> createState() =>
      _TrainingDayScreenState();
}

class _TrainingDayScreenState
    extends State<TrainingDayScreen> {
  late Future<TrainingDay> _trainingDayFuture;
  double _rpe = 5;
  String _feedback = '';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _trainingDayFuture = TrainingDayService.getTrainingDay(
      widget.trainingDayId,
    );
  }

  Future<void> _submitFeedback() async {
    setState(() => _isSubmitting = true);
    try {
      await TrainingDayService.updateTrainingDay(
        id: widget.trainingDayId,
        rpe: _rpe.toInt(),
        feedback: _feedback,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Feedback submitted'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Day'),
        centerTitle: true,
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
      ),
      body: FutureBuilder<TrainingDay>(
        future: _trainingDayFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('❌ Error: ${snapshot.error}'),
            );
          }

          final training = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  '${training.type} – ${training.distance} km @ ${training.pace ?? "-"}',
                  style:
                      Theme.of(
                        context,
                      ).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  training.description ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Rate of Perceived Exertion (1–10)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: _rpe,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: _rpe.toStringAsFixed(0),
                  onChanged: (value) {
                    setState(() => _rpe = value);
                  },
                ),

                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Your Feedback',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) => _feedback = value,
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed:
                      _isSubmitting
                          ? null
                          : _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child:
                      _isSubmitting
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                          )
                          : const Text('Submit Feedback'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
