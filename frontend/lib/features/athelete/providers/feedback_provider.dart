import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/training_day_feedback.dart';
import 'package:frontend/features/athelete/services/athlete_feedback_service.dart';

final feedbackForTrainingDayProvider = FutureProvider.family
    .autoDispose<TrainingDayFeedback?, int>((
      ref,
      trainingDayId,
    ) async {
      return await AthleteFeedbackService()
          .fetchFeedbackForTrainingDay(trainingDayId);
    });
