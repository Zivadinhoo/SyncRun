import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/models/assigned_plan.dart';
import 'package:http/http.dart' as http;

class AssignedPlansService {
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = 'http://192.168.0.37:3001';

  Future<List<AssignedPlan>> fetchAssignedPlans() async {
    final token = await _storage.read(key: 'accessToken');

    if (token == null) {
      throw Exception('No access token found.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/assigned-plans/my'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => AssignedPlan.fromJson(json))
          .toList();
    } else {
      throw Exception(
        'Failed to load assigned plans: ${response.body}',
      );
    }
  }

  Future<http.Response> updateAssignedPlan({
    required int id,
    required bool isCompleted,
    double? rpe,
    String? feedback,
  }) async {
    final token = await _storage.read(key: 'accessToken');

    final response = await http.patch(
      Uri.parse('$_baseUrl/assigned-plans/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'isCompleted': isCompleted,
        'rpe': rpe,
        'feedback': feedback,
      }),
    );

    return response;
  }
}
