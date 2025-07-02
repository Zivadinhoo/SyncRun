import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/models/training_day.dart';

final weeklyCompletionProvider =
    Provider.family<bool, List<TrainingDay>>((
      ref,
      trainingDays,
    ) {
      return trainingDays.isNotEmpty &&
          trainingDays.every(
            (day) => day.status == 'completed',
          );
    });
