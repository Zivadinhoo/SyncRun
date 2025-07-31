import 'package:flutter/material.dart';

Color getTypeColor(String type) {
  final lower = type.toLowerCase();

  if (lower.contains('easy')) {
    return Colors.lightBlue.shade100; // lagano, prijatno
  }

  if (lower.contains('tempo')) {
    return Colors
        .orange
        .shade200; // 🔸 tempo → narandžasta (Runna-style)
  }

  if (lower.contains('interval')) {
    return Colors.red.shade100; // kratko ali intenzivno
  }

  if (lower.contains('long')) {
    return Colors.green.shade100; // izdržljivost, sigurnost
  }

  if (lower.contains('race')) {
    return Colors.amber.shade200; // uzbudljivo, event-style
  }

  if (lower.contains('stretch')) {
    return Colors.yellow.shade100; // fleksibilnost, lagano
  }

  if (lower.contains('rest')) {
    return Colors.grey.shade300; // neutralno
  }

  return Colors.blueGrey.shade100; // fallback
}

String getTypeEmoji(String type) {
  final lower = type.toLowerCase();

  if (lower.contains('rest')) {
    return '🛌';
  }

  if (lower.contains('race')) {
    return '🏁';
  }

  if (lower.contains('stretch')) {
    return '🧘';
  }

  if (lower.contains('interval')) {
    return '⚡';
  }

  if (lower.contains('tempo')) {
    return '🎯';
  }

  if (lower.contains('long')) {
    return '🏃‍♂️';
  }

  if (lower.contains('easy')) {
    return '🏃';
  }

  return '📅'; // fallback za nepoznate tipove
}
