import 'dart:convert';
import 'package:frontend/features/models/training_day_feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AthleteFeedbackService {
  final String baseUrl = 'http://192.168.0.57:3001';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<TrainingDayFeedback?> fetchFeedbackForTrainingDay(
    int trainingDayId,
  ) async {
    final token = await _getToken();
    final url = Uri.parse(
      '$baseUrl/training-day-feedback/by-training-day/$trainingDayId',
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200 &&
        response.body.isNotEmpty) {
      final json = jsonDecode(response.body);
      return TrainingDayFeedback.fromJson(json);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception(
        'Failed to fetch feedback: ${response.body}',
      );
    }
  }

  Future<TrainingDayFeedback> createFeedback({
    required int trainingDayId,
    required String comment,
    required int rating,
  }) async {
    final token = await _getToken();
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

    if (response.statusCode == 201) {
      return TrainingDayFeedback.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception(
        'Failed to create feedback: ${response.body}',
      );
    }
  }

  Future<void> updateFeedback({
    required int feedbackId,
    required String comment,
    required int rating,
  }) async {
    final token = await _getToken();
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

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update feedback: ${response.body}',
      );
    }
  }
}
