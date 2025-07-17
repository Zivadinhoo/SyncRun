import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/athlete/providers/training_day_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TrainingDayScreen extends ConsumerStatefulWidget {
  final int trainingDayId;

  const TrainingDayScreen({
    super.key,
    required this.trainingDayId,
  });

  @override
  ConsumerState<TrainingDayScreen> createState() =>
      _TrainingDayScreenState();
}

class _TrainingDayScreenState
    extends ConsumerState<TrainingDayScreen> {
  int? selectedRpe;
  final _commentController = TextEditingController();
  bool isSubmitting = false;

  Future<void> _submitFeedback() async {
    if (selectedRpe == null) return;

    setState(() => isSubmitting = true);

    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'accessToken');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No access token")),
      );
      return;
    }

    final response = await http.patch(
      Uri.parse(
        'http://192.168.0.53:3001/training-days/${widget.trainingDayId}',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'rpe': selectedRpe,
        'comment': _commentController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Feedback submitted'),
        ),
      );
      Navigator.of(context).pop(); // vrati korisnika nazad
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '❌ Failed: ${response.statusCode} ${response.body}',
          ),
        ),
      );
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final trainingDayAsync = ref.watch(
      trainingDayProvider(widget.trainingDayId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Training Day')),
      body: trainingDayAsync.when(
        data:
            (trainingDay) => SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    trainingDay.name ?? 'Unititled',
                    style:
                        Theme.of(
                          context,
                        ).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trainingDay.description ??
                        'No description provided.',
                    style:
                        Theme.of(
                          context,
                        ).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.directions_run),
                      const SizedBox(width: 8),
                      Text(
                        '${trainingDay.distance?.toStringAsFixed(1) ?? '--'} km',
                        style:
                            Theme.of(
                              context,
                            ).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (trainingDay.duration != null)
                    Row(
                      children: [
                        const Icon(Icons.timer),
                        const SizedBox(width: 8),
                        Text(
                          '${trainingDay.duration} min',
                          style:
                              Theme.of(
                                context,
                              ).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  Text(
                    "Rate this session (RPE)",
                    style:
                        Theme.of(
                          context,
                        ).textTheme.titleMedium,
                  ),
                  Wrap(
                    spacing: 8,
                    children: List.generate(10, (index) {
                      final value = index + 1;
                      return ChoiceChip(
                        label: Text('$value'),
                        selected: selectedRpe == value,
                        onSelected: (_) {
                          setState(() {
                            selectedRpe = value;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText:
                          "Leave a comment (optional)",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isSubmitting
                              ? null
                              : _submitFeedback,
                      child:
                          isSubmitting
                              ? const CircularProgressIndicator()
                              : const Text(
                                'Submit Feedback',
                              ),
                    ),
                  ),
                ],
              ),
            ),
        loading:
            () => const Center(
              child: CircularProgressIndicator(),
            ),
        error:
            (error, _) =>
                Center(child: Text('Error: $error')),
      ),
    );
  }
}
