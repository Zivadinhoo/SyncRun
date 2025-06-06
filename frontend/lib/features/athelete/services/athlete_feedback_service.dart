import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/training_day_feedback.dart';

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
}
