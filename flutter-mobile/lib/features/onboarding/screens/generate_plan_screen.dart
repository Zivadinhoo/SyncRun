import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:frontend/features/onboarding/service/ai_plan_service.dart';
import 'package:frontend/router.dart';
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

    // ✅ Safe way to call provider logic after widget is fully mounted
    Future.microtask(() => _generate());
  }

  Future<void> _generate() async {
    final answers = ref.read(onboardingAnswersProvider);

    try {
      // 🔁 Call AI plan service
      await AiPlanService.generateAiPlan(answers, ref);

      // ✅ Mark onboarding as completed
      await const FlutterSecureStorage().write(
        key: 'hasFinishedOnboarding',
        value: 'true',
      );

      ref.invalidate(hasFinishedOnboardingProvider);

      // 🚀 Navigate to dashboard
      if (mounted) {
        context.go('/athlete/dashboard');
      }
    } catch (e) {
      print("❌ AI plan generation failed: $e");
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
                  children: const [
                    Text(
                      "🧠 Generating your personalized plan...",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    CircularProgressIndicator(),
                    SizedBox(height: 24),
                    Text(
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
