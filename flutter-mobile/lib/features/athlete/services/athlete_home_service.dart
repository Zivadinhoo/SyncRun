import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/constants.dart';
import 'package:frontend/features/models/athlete_home_data.dart';
import 'package:frontend/utils/http_headers.dart';

import 'package:http/http.dart' as http;

class AthleteHomeService {
  // ignore: unused_field
  final _storage = const FlutterSecureStorage();
  final _baseUrl = apiUrl;

  Future<AthleteHomeData> fetchHomeData() async {
    try {
      final headers = await getAuthorizedHeaders();

      final response = await http.get(
        Uri.parse('$_baseUrl/assigned-plans/athlete/home'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AthleteHomeData.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception(
          'Unauthorized. Please log in again.',
        );
      } else {
        throw Exception(
          'Failed to load home data: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
