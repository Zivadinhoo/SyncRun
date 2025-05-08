import 'dart:convert';
import 'dart:io';
import 'package:frontend/core/constants.dart';
import 'package:http/http.dart' as http;

class PlanService {
  final String baseUrl = apiUrl;

  Future<List<Map<String, dynamic>>> getPlans(
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/training-plans"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
          json.decode(response.body),
        );
      } else {
        throw Exception(
          "Failed to load plans: ${response.body}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPlanById(
    String id,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/training-plans/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          "Failed to load plan: ${response.body}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createPlan(
    Map<String, dynamic> planData,
    String token,
  ) async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePlan(
    String id,
    Map<String, dynamic> planData,
    String token,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/training-plans/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(planData),
      );

      if (response.statusCode != 200 &&
          response.statusCode != 204) {
        throw Exception(
          "Failed to update plan: ${response.body}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePlan(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/training-plans/$id"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode != 200) {
        throw Exception(
          "Failed to delete plan: ${response.body}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> assignPlanToAthlete(
    String planId,
    String athleteId,
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/training-plans/$planId/assign"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({"athleteId": athleteId}),
      );

      if (response.statusCode != 200) {
        throw Exception(
          "Failed to assign plan: ${response.body}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getPlansForAthlete(
    String athleteId,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          "$baseUrl/athletes/$athleteId/training-plans",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
          json.decode(response.body),
        );
      } else {
        throw Exception(
          "Failed to load athlete plans: ${response.body}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
