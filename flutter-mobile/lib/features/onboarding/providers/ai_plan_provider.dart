import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/service/ai_plan_service.dart';

final aiPlanProvider =
    FutureProvider<Map<String, dynamic>?>((ref) async {
      final plan = await AiPlanService.getMyPlan();
      return plan;
    });
