import 'package:flutter/material.dart';

class TrainingDayScreen extends StatelessWidget {
  final String planName;
  final String planDescription;
  final DateTime assignedAt;
  final bool isCompleted;

  const TrainingDayScreen({
    super.key,
    required this.planName,
    required this.planDescription,
    required this.assignedAt,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Training Plan Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              planName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(planDescription),
            const SizedBox(height: 20),
            Text(
              "Assigned: ${assignedAt.day}.${assignedAt.month}.${assignedAt.year}",
            ),
            const SizedBox(height: 8),
            Text(
              isCompleted
                  ? "Status: ✅ Completed"
                  : "Status: ⏳ Not completed",
              style: TextStyle(
                color:
                    isCompleted
                        ? Colors.green
                        : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Ovde može ići feedback dugme kasnije
              },
              child: const Text("Leave Feedback"),
            ),
          ],
        ),
      ),
    );
  }
}
