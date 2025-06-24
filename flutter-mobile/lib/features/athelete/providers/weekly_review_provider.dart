import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/models/weekly_review.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final weeklyReviewProvider = FutureProvider.family.autoDispose<
  WeeklyReview,
  WeeklyReviewParams
>((ref, params) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'accessToken');

  if (token == null) {
    print('❌ No token found');
    throw Exception('Unauthorized');
  }

  final uri = Uri.parse(
    'http://192.168.0.45:3001/training-days/weekly-summary',
  ).replace(
    queryParameters: {
      'planId':
          params.assignedPlanId
              .toString(), // ⬅️ OVO je ključno
      'startDate': params.startDate
          .toIso8601String()
          .substring(0, 10),
      'endDate': params.endDate.toIso8601String().substring(
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

  print('📥 Status: ${response.statusCode}');
  print('📦 Body: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return WeeklyReview.fromJson(data);
  } else {
    throw Exception('Failed to fetch weekly review');
  }
});

class WeeklyReviewParams {
  final int assignedPlanId; // ⬅️ PROMENA ovde
  final DateTime startDate;
  final DateTime endDate;

  const WeeklyReviewParams({
    required this.assignedPlanId,
    required this.startDate,
    required this.endDate,
  });
}
