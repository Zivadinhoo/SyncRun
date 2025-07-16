import 'package:flutter/material.dart';

class AiDayCard extends StatelessWidget {
  final String dayName;
  final String type;
  final dynamic distance;
  final dynamic pace;

  const AiDayCard({
    super.key,
    required this.dayName,
    required this.type,
    this.distance,
    this.pace,
  });

  @override
  Widget build(BuildContext context) {
    final isRestDay = type.toLowerCase() == 'rest';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor:
              isRestDay
                  ? Colors.grey.shade300
                  : Colors.orange.shade100,
          child: Text(
            isRestDay ? '🛌' : '🏃',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          "$dayName – $type",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isRestDay ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            isRestDay
                ? "Rest day"
                : "$distance km at $pace min/km",
            style: TextStyle(
              fontSize: 14,
              color:
                  isRestDay
                      ? Colors.grey.shade600
                      : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
