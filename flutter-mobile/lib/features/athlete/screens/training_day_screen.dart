import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    final themeColor = const Color(0xFFFFA726);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor.withOpacity(0.9),
        title: const Text("Training Day"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlanInfo(context, dateStr),
              const SizedBox(height: 20),
              _buildTrainingCard(context),
              const SizedBox(height: 20),
              if (!isCompleted)
                _buildFeedbackForm(context, themeColor)
              else if (isEditing)
                _buildEditFeedback(context, themeColor)
              else
                _buildReadOnlyFeedback(context, themeColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanInfo(
    BuildContext context,
    String dateStr,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.directions_run,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.planName,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.planDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14),
              const SizedBox(width: 6),
              Text(
                "Assigned: $dateStr",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.trainingDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
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
                        Text(
                          "Duration:",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.access_time,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text("${widget.duration} min"),
                      ],
                    ),
                  if (widget.tss != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "TSS:",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.show_chart,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${widget.tss!.toStringAsFixed(0)}",
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

  Widget _buildFeedbackForm(
    BuildContext context,
    Color themeColor,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "💬 Feedback (optional):",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _feedbackController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "How did the training feel?",
            filled: true,
            fillColor: theme.cardColor.withOpacity(0.9),
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
        Text(
          "💪 Rate the difficulty (RPE):",
          style: theme.textTheme.titleMedium?.copyWith(
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
            style: theme.textTheme.bodyMedium,
          ),
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

  Widget _buildEditFeedback(
    BuildContext context,
    Color themeColor,
  ) {
    final theme = Theme.of(context);
    final buttonColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "✏️ Edit Feedback",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _feedbackController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Update your feedback",
            filled: true,
            fillColor: theme.cardColor,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.dividerColor.withOpacity(0.3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "💪 Update RPE (difficulty):",
          style: theme.textTheme.titleMedium,
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
              child: Text(
                "Cancel",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReadOnlyFeedback(
    BuildContext context,
    Color themeColor,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDark
                ? const Color(0xFF173A2F)
                : Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.05),
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
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Training completed",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:
                      isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.feedback_outlined,
                size: 18,
                color:
                    isDark
                        ? Colors.white70
                        : Colors.black87,
              ),
              const SizedBox(width: 6),
              Text(
                "Feedback:",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color:
                      isDark
                          ? Colors.white
                          : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _feedbackController.text.isNotEmpty
                ? _feedbackController.text
                : "No feedback provided.",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color:
                  isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "💪 RPE (effort rating):",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color:
                  isDark
                      ? Colors.orange.shade200
                      : Colors.orange,
            ),
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
                        : (isDark
                            ? Colors.white30
                            : theme.dividerColor
                                .withOpacity(0.3)),
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
                color: themeColor,
              ),
              label: Text(
                "Edit Feedback",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: themeColor,
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
