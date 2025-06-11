import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/features/athelete/services/assigned_plans_service.dart';
import 'package:frontend/features/athelete/services/athlete_feedback_service.dart';
import 'package:frontend/models/training_day_feedback.dart';
import 'package:intl/intl.dart';

class TrainingDayScreen extends StatefulWidget {
  final String planName;
  final String planDescription;
  final DateTime assignedAt;
  final bool isCompleted;
  final int assignedPlanId;
  final int trainingDayId;

  const TrainingDayScreen({
    super.key,
    required this.planName,
    required this.planDescription,
    required this.assignedAt,
    required this.isCompleted,
    required this.assignedPlanId,
    required this.trainingDayId,
  });

  @override
  State<TrainingDayScreen> createState() =>
      _TrainingDayScreenState();
}

class _TrainingDayScreenState
    extends State<TrainingDayScreen> {
  bool isCompleted = false;
  final TextEditingController _feedbackController =
      TextEditingController();
  double rpe = 5;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.isCompleted;
    _loadFeedback();
  }

  void _loadFeedback() async {
    if (widget.trainingDayId == 0) {
      print("⚠️ No trainingDayId, skipping feedback load.");
      return;
    }

    try {
      final TrainingDayFeedback? feedback =
          await AthleteFeedbackService()
              .fetchFeedbackForTrainingDay(
                widget.trainingDayId,
              );

      print("💬 feedback: $feedback");

      if (feedback != null) {
        setState(() {
          _feedbackController.text = feedback.comment ?? '';
          rpe = (feedback.rating ?? 5).toDouble();
        });
      }
    } catch (e) {
      print("❌ Error loading feedback: $e");
    }
  }

  void _markAsCompleted() async {
    try {
      final response = await AssignedPlansService()
          .updateAssignedPlan(
            id: widget.assignedPlanId,
            isCompleted: true,
            rpe: rpe,
            feedback: _feedbackController.text,
          );

      if (response.statusCode == 200) {
        final updatedPlan = jsonDecode(response.body);

        // 👇 Kreiraj feedback zapis
        try {
          await AthleteFeedbackService().createFeedback(
            trainingDayId: widget.trainingDayId,
            comment: _feedbackController.text,
            rating: rpe.toInt(),
          );
          print("✅ Feedback successfully created");
        } catch (e) {
          print("❌ Error creating feedback: $e");
        }

        setState(() {
          isCompleted = updatedPlan['isCompleted'] ?? true;
          _feedbackController.text =
              updatedPlan['feedback'] ?? '';
          rpe = (updatedPlan['rpe'] ?? 5).toDouble();
        });

        Navigator.pop(context, true);
      } else {
        print(
          "⚠️ Failed to update training. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("❌ Error updating training: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat(
      'd.M.y',
    ).format(widget.assignedAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Training Plan Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.planName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(widget.planDescription),
            const SizedBox(height: 20),
            Text("Assigned: $dateStr"),
            const SizedBox(height: 8),
            Text(
              "Status: ${isCompleted ? "✅ Completed" : "⏳ Not completed"}",
              style: TextStyle(
                color:
                    isCompleted
                        ? Colors.green
                        : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            if (!isCompleted) ...[
              const Text("Feedback (optional):"),
              TextField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "How did the training feel?",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Rate the difficulty (RPE):"),
              Slider(
                value: rpe,
                min: 1,
                max: 10,
                divisions: 9,
                label: rpe.toStringAsFixed(0),
                onChanged: (value) {
                  setState(() {
                    rpe = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _markAsCompleted,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text("Mark as Completed"),
                ),
              ),
            ] else ...[
              const Text("✅ Training completed!"),
              const SizedBox(height: 12),
              Text(
                "Your Feedback: ${_feedbackController.text.isEmpty ? "No feedback provided." : _feedbackController.text}",
              ),
              Text("RPE: ${rpe.toStringAsFixed(0)}"),
            ],
          ],
        ),
      ),
    );
  }
}
