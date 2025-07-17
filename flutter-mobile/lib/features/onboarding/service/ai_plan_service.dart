import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/ai_generated_plan_provider.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/http_headers.dart';

class AiPlanService {
  static const _baseUrl = "http://192.168.0.53:3001";

  static Future<http.Response> generatePlan(
    OnboardingAnswers answers,
  ) async {
    final url = Uri.parse("$_baseUrl/ai-plan/generate");

    final headers = await getAuthorizedHeaders();
    final body = jsonEncode(answers.toJson());

    print("🔸 Sending AI plan request to: $url");
    print("🔸 Headers: $headers");
    print("🔸 Body: $body");

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    print("✅ Response status: ${response.statusCode}");
    print("✅ Response body: ${response.body}");

    return response;
  }

  static Future<void> generateAiPlan(
    OnboardingAnswers answers,
    WidgetRef ref,
  ) async {
    final response = await generatePlan(answers);

    if (response.statusCode != 201 &&
        response.statusCode != 200) {
      throw Exception(
        'Failed to generate AI plan: ${response.body}',
      );
    }

    try {
      final decoded = jsonDecode(response.body);
      final plan = decoded['data'];

      if (plan == null ||
          plan['metadata']?['weeks'] == null) {
        throw Exception("AI response missing weeks");
      }

      ref.read(aiGeneratedPlanProvider.notifier).state =
          plan;
    } catch (e) {
      throw Exception("Failed to parse AI plan: $e");
    }
  }

  static Future<Map<String, dynamic>?> getMyPlan() async {
    final url = Uri.parse("$_baseUrl/ai-plan/me");
    final headers = await getAuthorizedHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to fetch AI plan: ${response.body}",
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded['data'] == null ||
        decoded['data']['metadata'] == null) {
      print("⚠️ No metadata in plan.");
      return null;
    }

    return decoded['data']['metadata'];
  }
}
