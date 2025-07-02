import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/models/training_day.dart';

final _secureStorage = FlutterSecureStorage();

final trainingDaysProviderFamily = FutureProvider.family<
  List<TrainingDay>,
  int
>((ref, assignedPlanId) async {
  print(
    "📡 Starting fetch for training days (planId: $assignedPlanId)",
  );

  final token = await _secureStorage.read(
    key: 'accessToken',
  );
  if (token == null) {
    print("❌ No access token found.");
    throw Exception("No token found");
  }

  final url =
      'http://192.168.0.49:3001/training-days/by-assigned-plan/$assignedPlanId';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  print("📥 Status: ${response.statusCode}");
  print("📦 Body: ${response.body}");

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final days =
        data
            .map((json) => TrainingDay.fromJson(json))
            .toList();
    print("✅ Parsed ${days.length} training days");
    return days;
  } else {
    print(
      "❌ Failed to load training days. Status: ${response.statusCode}",
    );
    throw Exception('Failed to load training days');
  }
});
