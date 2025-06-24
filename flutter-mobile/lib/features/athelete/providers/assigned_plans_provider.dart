import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/features/models/assigned_plan.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Secure storage
final _secureStorage = FlutterSecureStorage();

/// Provider koji vraća listu dodeljenih planova
final assignedPlansFutureProvider =
    FutureProvider.autoDispose<List<AssignedPlan>>((
      ref,
    ) async {
      final token = await _secureStorage.read(
        key: 'accessToken',
      );

      if (token == null) {
        print("❌ No token found in secure storage");
        throw Exception("No token found");
      }

      print(
        "📡 Fetching assigned plans with token: $token",
      );

      final response = await http.get(
        Uri.parse(
          'http://192.168.0.45:3001/assigned-plan/mine',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("📥 Status: ${response.statusCode}");
      print("📦 Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(
          response.body,
        );
        return data
            .map((e) => AssignedPlan.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to fetch assigned plans');
      }
    });

/// Provider koji vraća ID aktivnog plana sa backenda
final activePlanIdProvider = FutureProvider<int?>((
  ref,
) async {
  final token = await _secureStorage.read(
    key: 'accessToken',
  );
  if (token == null) throw Exception("No token found");

  final response = await http.get(
    Uri.parse('http://192.168.0.45:3001/users/me'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['activeAssignedPlanId'] as int?;
  } else {
    throw Exception('Failed to load user info');
  }
});

/// Provider koji postavlja aktivni plan i osvežava activePlanIdProvider
final setActivePlanProvider = Provider<
  Future<void> Function(int)
>((ref) {
  return (int assignedPlanId) async {
    final token = await _secureStorage.read(
      key: 'accessToken',
    );
    if (token == null) throw Exception("No token");

    final response = await http.post(
      Uri.parse(
        'http://192.168.0.45:3001/users/set-active-plan',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'assignedPlanId': assignedPlanId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to set active plan');
    }

    // 🔄 Refreshuj activePlanId
    ref.invalidate(activePlanIdProvider);
  };
});
