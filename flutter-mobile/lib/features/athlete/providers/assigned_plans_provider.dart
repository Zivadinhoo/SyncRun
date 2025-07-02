import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/features/models/assigned_plan.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _secureStorage = FlutterSecureStorage();

final assignedPlansFutureProvider =
    FutureProvider.autoDispose<List<AssignedPlan>>((
      ref,
    ) async {
      final token = await _secureStorage.read(
        key: 'accessToken',
      );

      if (token == null) {
        print("❌ No token found");
        throw Exception("No token found");
      }

      final response = await http.get(
        Uri.parse(
          'http://192.168.0.49:3001/assigned-plan/mine',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(
          response.body,
        );
        final allPlans =
            data
                .map((e) => AssignedPlan.fromJson(e))
                .toList();

        // 🔁 Ukloni duplikate po plan.id
        final Map<int, AssignedPlan> uniquePlansMap = {};
        for (final plan in allPlans) {
          uniquePlansMap[plan.id] = plan;
        }

        return uniquePlansMap.values.toList();
      } else {
        throw Exception('Failed to fetch assigned plans');
      }
    });
