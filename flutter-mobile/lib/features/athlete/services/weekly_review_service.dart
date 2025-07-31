import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../models/weekly_review.dart';

class WeeklyReviewService {
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = 'http://192.168.0.57:3001';

  Future<WeeklyReview> fetchWeeklyReview({
    required int athleteId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final token = await _storage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('No access token found');
    }

    final uri = Uri.parse(
      '$_baseUrl/training-days/weekly-summary',
    ).replace(
      queryParameters: {
        'athleteId': athleteId.toString(),

        'startDate': startDate.toIso8601String().substring(
          0,
          10,
        ),
        'endDate': endDate.toIso8601String().substring(
          0,
          10,
        ),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch weekly review: ${response.body}',
      );
    }

    final data = jsonDecode(response.body);
    return WeeklyReview.fromJson(data);
  }
}
