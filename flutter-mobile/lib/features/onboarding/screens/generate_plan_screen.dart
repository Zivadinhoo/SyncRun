import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:frontend/features/onboarding/service/ai_plan_service.dart';
import 'package:go_router/go_router.dart';

class GeneratePlanScreen extends ConsumerStatefulWidget {
  const GeneratePlanScreen({super.key});

  @override
  ConsumerState<GeneratePlanScreen> createState() =>
      _GeneratePlanScreenState();
}

class _GeneratePlanScreenState
    extends ConsumerState<GeneratePlanScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  Future<void> _generate() async {
    final answers = ref.read(onboardingAnswersProvider);
    try {
      await AiPlanService.generateAiPlan(answers);
      context.go(
        '/athlete-dashboard',
      ); // 👈 nakon uspešnog generisanja
    } catch (e) {
      print("❌ AI plan generation failed: $e");
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to generate plan. Please try again.",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            isLoading
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "🧠 Generating your personalized plan...",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    const Text(
                      "This may take a few seconds.\nHang tight!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 40,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Something went wrong",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _generate,
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
      ),
    );
  }
}
