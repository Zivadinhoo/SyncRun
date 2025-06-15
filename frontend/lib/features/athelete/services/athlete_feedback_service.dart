import 'dart:convert';
import 'package:frontend/features/models/training_day_feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AthleteFeedbackService {
  final String baseUrl = 'http://192.168.0.37:3001';

  Future<TrainingDayFeedback?> fetchFeedbackForTrainingDay(
    int trainingDayId,
  ) async {
    final url = Uri.parse(
      "$baseUrl/training-day-feedback/by-training-day/$trainingDayId",
    );

    print(
      "🌐 Fetching feedback for trainingDayId: $trainingDayId",
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    print("🔐 Using token: $token");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    print("📥 Feedback status: ${response.statusCode}");
    print("📦 Feedback body: ${response.body}");

    if (response.statusCode == 200 &&
        response.body.isNotEmpty) {
      final json = jsonDecode(response.body);
      return TrainingDayFeedback.fromJson(json);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load feedback');
    }
  }

  Future<void> createFeedback({
    required int trainingDayId,
    required String comment,
    required int rating,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final url = Uri.parse('$baseUrl/training-day-feedback');
    final body = jsonEncode({
      'trainingDayId': trainingDayId,
      'comment': comment,
      'rating': rating,
    });

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print("📤 Sending feedback: $body");
    print("📤 Status code: ${response.statusCode}");

    if (response.statusCode != 201) {
      throw Exception('Failed to create feedback');
    }
  }

  Future<void> updateFeedback({
    required int feedbackId,
    required String comment,
    required int rating,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final url = Uri.parse(
      '$baseUrl/training-day-feedback/$feedbackId',
    );
    final body = jsonEncode({
      'comment': comment,
      'rating': rating,
    });

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print("📝 Updating feedback: $body");
    print("📝 Status code: ${response.statusCode}");

    if (response.statusCode != 200) {
      throw Exception('Failed to update feedback');
    }
  }
}
