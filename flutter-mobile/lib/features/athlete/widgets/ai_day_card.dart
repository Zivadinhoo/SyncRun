import 'package:flutter/material.dart';

class AiDayCard extends StatelessWidget {
  final String dayName;
  final String type;
  final dynamic distance;
  final dynamic pace;
  final String status;

  const AiDayCard({
    super.key,
    required this.dayName,
    required this.type,
    required this.status,
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
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isRestDay
                    ? "Rest day"
                    : "$distance km at $pace",
                style: TextStyle(
                  fontSize: 14,
                  color:
                      isRestDay
                          ? Colors.grey.shade600
                          : Colors.black87,
                ),
              ),
              if (!isRestDay)
                Text(
                  _getStatusEmoji(status),
                  style: const TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusEmoji(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return '✅';
      case 'missed':
        return '❌';
      default:
        return '⏳';
    }
  }
}
