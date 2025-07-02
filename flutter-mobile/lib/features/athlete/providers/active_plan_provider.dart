import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/features/models/assigned_plan.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Secure storage
final _secureStorage = FlutterSecureStorage();

/// Provider koji vraća ID aktivnog plana sa backenda
final activePlanIdProvider = FutureProvider<int?>((
  ref,
) async {
  final token = await _secureStorage.read(
    key: 'accessToken',
  );
  if (token == null) throw Exception("No token found");

  final response = await http.get(
    Uri.parse('http://192.168.0.49:3001/users/me'),
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

/// Provider koji postavlja aktivni plan i invalidira cache
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
        'http://192.168.0.49:3001/users/set-active-plan',
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

    // 🔁 Osvetli provider da se učita novi aktivni plan
    ref.invalidate(activePlanIdProvider);
  };
});
