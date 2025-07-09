import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/models/assigned_plan.dart';

final _secureStorage = FlutterSecureStorage();

/// ✅ Provider koji vraća ceo aktivni plan, ne samo ID
final activeAssignedPlanProvider = FutureProvider<
  AssignedPlan
>((ref) async {
  final token = await _secureStorage.read(
    key: 'accessToken',
  );
  if (token == null) throw Exception("❌ No token found");

  final response = await http.get(
    Uri.parse('http://192.168.0.49:3001/users/me'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final planJson = data['activeAssignedPlan'];

    if (planJson == null) {
      throw Exception("❌ No active assigned plan found");
    }

    return AssignedPlan.fromJson(planJson);
  } else {
    throw Exception('❌ Failed to fetch user info');
  }
});
