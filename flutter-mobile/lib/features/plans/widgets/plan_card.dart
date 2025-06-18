import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final String planName;
  final int trainingDays;
  final int athletesAssigned;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAssign;

  const PlanCard({
    Key? key,
    required this.planName,
    required this.trainingDays,
    required this.athletesAssigned,
    required this.onEdit,
    required this.onDelete,
    required this.onAssign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
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
            const SizedBox(height: 8),
            Text("Training Days: $trainingDays"),
            Text("Athletes Assigned: $athletesAssigned"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.orange,
                  ),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: onDelete,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.person_add,
                    color: Colors.green,
                  ),
                  onPressed: onAssign,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
