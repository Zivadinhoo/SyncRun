import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/features/athelete/services/assigned_plans_service.dart';
import 'package:frontend/features/athelete/services/athlete_feedback_service.dart';
import 'package:frontend/features/models/training_day_feedback.dart';
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
  bool isEditing = false;

  final TextEditingController _feedbackController =
      TextEditingController();
  double rpe = 5;
  int? feedbackId;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.isCompleted;
    _loadFeedback();
  }

  void _loadFeedback() async {
    if (widget.trainingDayId == 0) return;

    try {
      final feedback = await AthleteFeedbackService()
          .fetchFeedbackForTrainingDay(
            widget.trainingDayId,
          );
      if (feedback != null) {
        setState(() {
          _feedbackController.text = feedback.comment ?? '';
          rpe = (feedback.rating ?? 5).toDouble();
          feedbackId = feedback.id;
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
        await AthleteFeedbackService().createFeedback(
          trainingDayId: widget.trainingDayId,
          comment: _feedbackController.text,
          rating: rpe.toInt(),
        );

        setState(() {
          isCompleted = true;
        });

        if (!mounted) return;
        Navigator.pop(context, true);
      }
    } catch (e) {
      print("❌ Error updating training: $e");
    }
  }

  void _saveFeedbackChanges() async {
    if (feedbackId == null) return;

    try {
      await AthleteFeedbackService().updateFeedback(
        feedbackId: feedbackId!,
        comment: _feedbackController.text,
        rating: rpe.toInt(),
      );

      setState(() => isEditing = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Feedback updated")),
      );
    } catch (e) {
      print("❌ Failed to update feedback: $e");
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
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.planName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(widget.planDescription),
                  const SizedBox(height: 12),
                  Text("📅 Assigned: $dateStr"),
                  Row(
                    children: [
                      Icon(
                        isCompleted
                            ? Icons.check_circle
                            : Icons.schedule,
                        color:
                            isCompleted
                                ? Colors.green
                                : Colors.orange,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isCompleted
                            ? "Status: Completed"
                            : "Status: Not completed",
                        style: TextStyle(
                          color:
                              isCompleted
                                  ? Colors.green
                                  : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 👇 Ako nije završen
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
                onChanged:
                    (value) => setState(() => rpe = value),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Mark as Completed"),
                  onPressed: _markAsCompleted,
                ),
              ),

              // 👇 Ako je završen i edituje feedback
            ] else if (isEditing) ...[
              const Text("✏️ Edit your feedback:"),
              TextField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Update your feedback",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Update RPE:"),
              Slider(
                value: rpe,
                min: 1,
                max: 10,
                divisions: 9,
                label: rpe.toStringAsFixed(0),
                onChanged:
                    (value) => setState(() => rpe = value),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _saveFeedbackChanges,
                    child: const Text("💾 Save Changes"),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed:
                        () => setState(
                          () => isEditing = false,
                        ),
                    child: const Text("Cancel"),
                  ),
                ],
              ),

              // 👇 Ako je završen i samo prikaz feedbacka
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 20,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Training completed",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "📝 ",
                          style: TextStyle(fontSize: 18),
                        ),
                        Expanded(
                          child: Text(
                            _feedbackController
                                    .text
                                    .isNotEmpty
                                ? _feedbackController.text
                                : "No feedback provided.",
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Text(
                          "💪 ",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "RPE: ${rpe.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed:
                            () => setState(
                              () => isEditing = true,
                            ),
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                        ),
                        label: const Text("Edit Feedback"),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
