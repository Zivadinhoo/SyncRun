import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/models/training_day_model.dart';
import 'package:http/http.dart' as http;

final trainingDayProvider = FutureProvider.family<
  TrainingDayModel,
  int
>((ref, id) async {
  const baseUrl = 'http://192.168.0.53:3001';
  const storage = FlutterSecureStorage();

  final token = await storage.read(key: 'accessToken');
  if (token == null) throw Exception('No token found');

  final response = await http.get(
    Uri.parse('$baseUrl/training-days/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return TrainingDayModel.fromJson(json);
  } else {
    throw Exception(
      'Failed to fetch training day: ${response.statusCode}',
    );
  }
});
