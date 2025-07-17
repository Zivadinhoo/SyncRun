// lib/features/onboarding/providers/ai_generated_plan_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/models/ai_training_plan.dart';

final aiGeneratedPlanProvider =
    StateProvider<AiTrainingPlan?>((ref) => null);
