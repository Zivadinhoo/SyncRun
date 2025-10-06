import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/features/models/training_day.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TrainingDayService {
  static const String baseUrl =
      'http://localhost:3001'; // PROMENI AKO IDE NA CLOUD

  static final _storage = const FlutterSecureStorage();

  static Future<String?> _getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<TrainingDay> getTrainingDay(int id) async {
    final token = await _getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/training-days/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('❌ Failed to fetch training day');
    }

    final data = jsonDecode(response.body);
    return TrainingDay.fromJson(data);
  }

  static Future<void> updateTrainingDay({
    required int id,
    required int rpe,
    required String feedback,
  }) async {
    final token = await _getAccessToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/training-days/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'rpe': rpe,
        'feedback': feedback,
        'status': 'completed',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('❌ Failed to update training day');
    }
  }
}
