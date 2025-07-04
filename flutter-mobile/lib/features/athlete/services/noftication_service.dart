import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:frontend/features/models/training_day.dart';
import 'package:collection/collection.dart'; // ⬅️ Dodaj ovo u pubspec.yaml: collection: ^1.17.2

class NotificationService {
  static final FlutterLocalNotificationsPlugin
  _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Android settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS settings
    const iosSettings = DarwinInitializationSettings();

    // Inicijalizacija
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initSettings);

    // Timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation('Europe/Belgrade'),
    ); // ili tvoja zona
  }

  /// Zakaži notifikaciju za 07:00 ako postoji trening za danas
  static Future<void> scheduleReminderIfTrainingToday(
    List<TrainingDay> trainingDays,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final trainingToday = trainingDays.firstWhereOrNull(
      (day) => isSameDate(day.date, today),
    );

    if (trainingToday == null) return;

    final scheduledTime = tz.TZDateTime.local(
      today.year,
      today.month,
      today.day,
      7,
      0,
    );
    final nowTZ = tz.TZDateTime.now(tz.local);

    final message = _generateMessage(trainingToday);

    if (scheduledTime.isBefore(nowTZ)) {
      // Ako je već prošlo 07:00 – odmah prikaži
      await _notificationsPlugin.show(
        0,
        '🏃 Today\'s Training',
        message,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel',
            'Daily Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } else {
      // Inače zakaži za 07:00
      await _notificationsPlugin.zonedSchedule(
        0,
        '🏃 Today\'s Training',
        message,
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel',
            'Daily Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation
                .absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  static String _generateMessage(TrainingDay day) {
    if (day.title.isNotEmpty && day.duration > 0) {
      return '${day.title} · ${day.duration} min';
    } else if (day.title.isNotEmpty) {
      return 'You’ve got: ${day.title}';
    } else {
      return 'You have a training today – let’s do it!';
    }
  }
}
