import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/utils/running_type.dart';

class AiDayCard extends StatelessWidget {
  final String dayName;
  final String? type;
  final double? distance;
  final String? pace;
  final String? status;
  final DateTime? date;

  const AiDayCard({
    super.key,
    required this.dayName,
    this.type,
    this.status,
    this.distance,
    this.pace,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    final typeText = type ?? '';
    final formattedDate =
        date != null ? DateFormat.MMMd().format(date!) : '';

    final isRunDay = !_isPassiveDay(typeText);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 6,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji avatar with dynamic color
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: getTypeColor(typeText),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                getTypeEmoji(typeText),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 16),

            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    '$dayName${type != null ? ' – $type' : ''}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isRunDay
                        ? '${distance?.toStringAsFixed(0) ?? '-'} km at ${pace ?? '-'}'
                        : 'Rest day',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  if (formattedDate.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 2,
                      ),
                      child: Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Status emoji – only for active run days
            if (isRunDay)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  _getStatusEmoji(status),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getStatusEmoji(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case 'completed':
        return '✅';
      case 'missed':
        return '❌';
      default:
        return '⏳';
    }
  }

  bool _isPassiveDay(String type) {
    final t = type.toLowerCase();
    return t.contains('rest') || t.contains('stretch');
  }
}
