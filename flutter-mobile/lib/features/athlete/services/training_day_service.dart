import 'package:frontend/core/constants.dart';
import 'package:frontend/utils/http_headers.dart';
import 'package:http/http.dart' as http;

class TrainingDaysService {
  final _baseUrl = apiUrl;

  Future<void> markAsCompleted(int trainingDayId) async {
    try {
      final headers = await getAuthorizedHeaders();

      final response = await http.patch(
        Uri.parse(
          '$_baseUrl/training-days/$trainingDayId/complete',
        ),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to mark training day as completed: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
