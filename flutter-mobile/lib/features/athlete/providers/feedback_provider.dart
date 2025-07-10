// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontend/features/models/training_day_feedback.dart';
// import 'package:frontend/features/athlete/services/athlete_feedback_service.dart';

// final athleteFeedbackServiceProvider = Provider(
//   (ref) => AthleteFeedbackService(),
// );

// final feedbackForTrainingDayProvider = FutureProvider.family
//     .autoDispose<TrainingDayFeedback?, int>((
//       ref,
//       trainingDayId,
//     ) async {
//       final service = ref.watch(
//         athleteFeedbackServiceProvider,
//       );
//       return service.fetchFeedbackForTrainingDay(
//         trainingDayId,
//       );
//     });

// final feedbackControllerProvider = Provider((ref) {
//   final service = ref.watch(athleteFeedbackServiceProvider);

//   return ({
//     required int trainingDayId,
//     required String comment,
//     required int rating,
//     TrainingDayFeedback? existingFeedback,
//   }) async {
//     if (existingFeedback != null) {
//       await service.updateFeedback(
//         feedbackId: existingFeedback.id,
//         comment: comment,
//         rating: rating,
//       );
//     } else {
//       await service.createFeedback(
//         trainingDayId: trainingDayId,
//         comment: comment,
//         rating: rating,
//       );
//     }

//     ref.invalidate(
//       feedbackForTrainingDayProvider(trainingDayId),
//     );
//   };
// });
