import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/features/athlete/services/assigned_plans_service.dart';
import 'package:frontend/features/athlete/services/athlete_feedback_service.dart';
import 'package:frontend/features/athlete/services/training_day_service.dart';
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
    print("👉 CLICKED: _markAsCompleted");

    try {
      final feedbackService = AthleteFeedbackService();

      if (feedbackId != null) {
        print(
          "🛠️ Updating existing feedback ID: $feedbackId",
        );
        await feedbackService.updateFeedback(
          feedbackId: feedbackId!,
          comment: _feedbackController.text,
          rating: rpe.toInt(),
        );
      } else {
        print("➕ Creating new feedback...");
        final feedback = await feedbackService
            .createFeedback(
              trainingDayId: widget.trainingDayId,
              comment: _feedbackController.text,
              rating: rpe.toInt(),
            );
        feedbackId = feedback.id;
        print("✅ Created feedback with ID: ${feedback.id}");
      }

      print(
        "📤 Sending PATCH to mark training day as completed...",
      );
      await TrainingDaysService().markAsCompleted(
        widget.trainingDayId,
      );
      print("✅ Training day marked as completed");

      if (!mounted) return;

      setState(() => isCompleted = true);
      Navigator.pop(context, true);
    } catch (e, stack) {
      print("❌ ERROR inside _markAsCompleted: $e");
      print(stack);
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
    final themeColor = Colors.orange.shade300;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text("Training Day"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlanInfo(dateStr, themeColor),
              const SizedBox(height: 20),
              if (!isCompleted)
                _buildFeedbackForm(themeColor),
              if (isCompleted && isEditing)
                _buildEditFeedback(themeColor),
              if (isCompleted && !isEditing)
                _buildReadOnlyFeedback(themeColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanInfo(String dateStr, Color themeColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.planName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(widget.planDescription),
          const SizedBox(height: 12),
          Text("📅 Assigned: $dateStr"),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isCompleted
                    ? Icons.check_circle
                    : Icons.schedule,
                color:
                    isCompleted ? Colors.green : themeColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                isCompleted ? "Completed" : "Not completed",
                style: TextStyle(
                  color:
                      isCompleted
                          ? Colors.green
                          : themeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackForm(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "💬 Feedback (optional):",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _feedbackController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "How did the training feel?",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        const Text("💪 Rate the difficulty (RPE):"),
        Slider(
          value: rpe,
          min: 1,
          max: 10,
          divisions: 9,
          label: rpe.toStringAsFixed(0),
          activeColor: themeColor,
          onChanged: (value) => setState(() => rpe = value),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text("Mark as Completed"),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
            ),
            onPressed: _markAsCompleted,
          ),
        ),
      ],
    );
  }

  Widget _buildEditFeedback(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("✏️ Edit Feedback:"),
        const SizedBox(height: 8),
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
          activeColor: themeColor,
          onChanged: (value) => setState(() => rpe = value),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            ElevatedButton(
              onPressed: _saveFeedbackChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
              ),
              child: const Text("💾 Save"),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed:
                  () => setState(() => isEditing = false),
              child: const Text("Cancel"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReadOnlyFeedback(Color themeColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "📝 ",
                style: TextStyle(fontSize: 18),
              ),
              Expanded(
                child: Text(
                  _feedbackController.text.isNotEmpty
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
              Text("RPE: ${rpe.toStringAsFixed(0)}"),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed:
                  () => setState(() => isEditing = true),
              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
              ),
              label: const Text("Edit Feedback"),
              style: TextButton.styleFrom(
                foregroundColor: themeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
