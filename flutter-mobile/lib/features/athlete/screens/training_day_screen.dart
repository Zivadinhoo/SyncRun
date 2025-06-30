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
  final int duration;
  final double? tss;

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
    required this.duration,
    required this.tss,
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Training marked as completed"),
        ),
      );
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

      setState(() {
        isCompleted = true;
        isEditing = false;
      });

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
        color: Colors.orange.shade200,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.directions_run, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.planName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (widget.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Completed",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.planDescription,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 6),
              Text(
                "Assigned: $dateStr",
                style: const TextStyle(fontSize: 14),
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
        color: Colors.orange[200], // pojačana narandžasta
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade200.withOpacity(0.6),
            blurRadius: 10,
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.trainingDescription,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          if ((widget.duration > 0) || widget.tss != null)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Wrap(
                spacing: 24,
                runSpacing: 8,
                children: [
                  if (widget.duration > 0)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Duration: ${widget.duration} min",
                        ),
                      ],
                    ),
                  if (widget.tss != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.show_chart,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "TSS: ${widget.tss!.toStringAsFixed(0)}",
                        ),
                      ],
                    ),
                ],
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _feedbackController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "How did the training feel?",
            hintStyle: TextStyle(
              color: Colors.grey.shade600,
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: themeColor.withOpacity(0.8),
                width: 1.4,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "💪 Rate the difficulty (RPE):",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        Slider(
          value: rpe,
          min: 1,
          max: 10,
          divisions: 9,
          label: rpe.toStringAsFixed(0),
          activeColor: themeColor.withOpacity(0.9),
          inactiveColor: themeColor.withOpacity(0.3),
          onChanged: (value) => setState(() => rpe = value),
        ),
        Center(
          child: Text(
            "RPE: ${rpe.toStringAsFixed(0)} / 10",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text("Mark as Completed"),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor.withOpacity(0.95),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _markAsCompleted,
          ),
        ),
      ],
    );
  }

  Widget _buildEditFeedback(Color themeColor) {
    final Color buttonColor = Colors.orange.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "✏️ Edit Feedback",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _feedbackController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Update your feedback",
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "💪 Update RPE (difficulty):",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Slider(
          value: rpe,
          min: 1,
          max: 10,
          divisions: 9,
          label: rpe.toStringAsFixed(0),
          activeColor: buttonColor.withOpacity(0.9),
          inactiveColor: buttonColor.withOpacity(0.3),
          onChanged: (value) => setState(() => rpe = value),
        ),
        Text("RPE: ${rpe.toStringAsFixed(0)} / 10"),
        const SizedBox(height: 24),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _saveFeedbackChanges,
              icon: const Icon(Icons.save),
              label: const Text("Save"),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed:
                  () => setState(() => isEditing = false),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black54),
              ),
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
          Row(
            children: [
              Tooltip(
                message: "Training marked as done",
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Training completed",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "RPE: ${rpe.toStringAsFixed(0)} / 10",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 6),
          Text(
            _feedbackController.text.isNotEmpty
                ? _feedbackController.text
                : "No feedback provided.",
            style: const TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "💪 RPE (effort rating):",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(10, (index) {
              final isFilled = index < rpe.round();
              return Icon(
                isFilled ? Icons.star : Icons.star_border,
                size: 20,
                color:
                    isFilled
                        ? themeColor
                        : Colors.grey.shade300,
              );
            }),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed:
                  () => setState(() => isEditing = true),
              icon: Icon(
                Icons.edit_outlined,
                size: 18,
                color: Colors.orange.shade400,
              ),
              label: Text(
                "Edit Feedback",
                style: TextStyle(
                  color: Colors.orange.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
