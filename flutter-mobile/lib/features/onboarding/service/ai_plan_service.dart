import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/features/onboarding/models/onboarding_answer.dart';
import 'package:frontend/utils/http_headers.dart';

class AiPlanService {
  static const _baseUrl = "http://localhost:3001";

  static Future<http.Response> generatePlan(
    OnboardingAnswers answers,
  ) async {
    final url = Uri.parse("$_baseUrl/api/ai-plan-generate");

    final headers =
        await getAuthorizedHeaders(); // ili samo {'Content-Type': 'application/json'} ako ne koristiš token
    final body = jsonEncode(answers.toJson());

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    return response;
  }
}
