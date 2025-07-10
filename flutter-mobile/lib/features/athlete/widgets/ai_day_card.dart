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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              Text(
                isRestDay ? "🛌" : "🏃‍♂️",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "$dayName – $type",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        isRestDay
                            ? Colors.grey
                            : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
        ],
      ),
    );
  }
}
