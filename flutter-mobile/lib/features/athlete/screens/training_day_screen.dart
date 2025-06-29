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
  final String trainingTitle;
  final String trainingDescription;

  const TrainingDayScreen({
    super.key,
    required this.planName,
    required this.planDescription,
    required this.assignedAt,
    required this.isCompleted,
    required this.assignedPlanId,
    required this.trainingDayId,
    required this.trainingTitle,
    required this.trainingDescription,
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
    try {
      final feedbackService = AthleteFeedbackService();

      if (feedbackId != null) {
        await feedbackService.updateFeedback(
          feedbackId: feedbackId!,
          comment: _feedbackController.text,
          rating: rpe.toInt(),
        );
      } else {
        final feedback = await feedbackService
            .createFeedback(
              trainingDayId: widget.trainingDayId,
              comment: _feedbackController.text,
              rating: rpe.toInt(),
            );
        feedbackId = feedback.id;
      }

      await TrainingDaysService().markAsCompleted(
        widget.trainingDayId,
      );

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
    final themeColor = Colors.orange.shade200;

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
              _buildTrainingCard(),
              const SizedBox(height: 20),
              if (!isCompleted)
                _buildFeedbackForm(themeColor)
              else if (isEditing)
                _buildEditFeedback(themeColor)
              else
                _buildReadOnlyFeedback(themeColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanInfo(String dateStr, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text("🏃 ", style: TextStyle(fontSize: 20)),
              Text(
                "5K Beginner Plan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "🧾 4-week plan for beginner runners aiming to complete a 5K race.",
          ),
          const SizedBox(height: 12),
          Text("🗓️ Assigned: $dateStr"),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 20,
              ),
              const SizedBox(width: 6),
              const Text(
                "Completed",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade100,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.trainingTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.trainingDescription,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
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
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              SizedBox(width: 8),
              Text(
                "Training completed",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "✏️ ",
                style: TextStyle(fontSize: 18),
              ),
              Expanded(
                child: Text(
                  _feedbackController.text.isNotEmpty
                      ? _feedbackController.text
                      : "No feedback provided.",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text("💪 RPE: ${rpe.toStringAsFixed(0)}"),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed:
                () => setState(() => isEditing = true),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text("Edit Feedback"),
            style: TextButton.styleFrom(
              foregroundColor: themeColor,
            ),
          ),
        ],
      ),
    );
  }
}
