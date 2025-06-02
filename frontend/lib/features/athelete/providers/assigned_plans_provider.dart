import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/assigned_plan.dart';
import '../services/assigned_plans_service.dart';

final assignedPlansFutureProvider =
    FutureProvider<List<AssignedPlan>>((ref) async {
      final service = AssignedPlansService();
      return await service.fetchAssignedPlans();
    });
