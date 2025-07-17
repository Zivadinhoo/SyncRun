import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/models/ai_training_plan.dart';
import 'package:frontend/features/onboarding/service/ai_plan_service.dart';

final aiPlanProvider = FutureProvider<AiTrainingPlan?>((
  ref,
) async {
  final metadata = await AiPlanService.getMyPlan();
  if (metadata == null) return null;
  return AiTrainingPlan.fromJson(metadata);
});
