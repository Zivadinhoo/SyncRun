import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/models/assigned_plan.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final assignedPlansFutureProvider =
    FutureProvider.autoDispose<List<AssignedPlan>>((
      ref,
    ) async {
      const secureStorage = FlutterSecureStorage();
      final token = await secureStorage.read(
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
          'http://192.168.0.37:3001/assigned-plans/mine',
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
