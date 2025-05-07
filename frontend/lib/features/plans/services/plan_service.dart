import 'dart:convert';
import 'package:frontend/core/constants.dart';
import 'package:http/http.dart' as http;

class PlanService {
  final String baseUrl = apiUrl;

  Future<List<Map<String, dynamic>>> getPlans(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse("$baseUrl/training-plans"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> plans = json.decode(
        response.body,
      );
      return List<Map<String, dynamic>>.from(plans);
    } else {
      throw Exception(
        "Failed to load plans: ${response.body}",
      );
    }
  }

  Future<void> createPlan(
    Map<String, dynamic> planData,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/training-plans"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(planData),
    );

    if (response.statusCode != 201) {
      throw Exception(
        "Failed to create plan: ${response.body}",
      );
    }
  }

  Future<void> deletePlan(String id, String token) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/training-plans/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to delete plan: ${response.body}",
      );
    }
  }
}
