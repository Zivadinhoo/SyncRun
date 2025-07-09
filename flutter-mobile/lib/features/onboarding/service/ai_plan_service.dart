import 'dart:convert';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/http_headers.dart';

class AiPlanService {
  static const _baseUrl = "http://192.168.0.49:3001";

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
  ) async {
    final response = await generatePlan(answers);
    if (response.statusCode != 201 &&
        response.statusCode != 200) {
      throw Exception(
        'Failed to generate AI plan: ${response.body}',
      );
    }
  }
}
