import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/models/training_day.dart';

final _secureStorage = FlutterSecureStorage();

final trainingDaysProvider = FutureProvider.family<
  List<TrainingDay>,
  int
>((ref, assignedPlanId) async {
  final token = await _secureStorage.read(
    key: 'accessToken',
  );
  if (token == null) throw Exception("No token found");

  final response = await http.get(
    Uri.parse(
      'http://192.168.0.45:3001/training-days/by-plan/$assignedPlanId',
    ),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((json) => TrainingDay.fromJson(json))
        .toList();
  } else {
    throw Exception('Failed to load training days');
  }
});
