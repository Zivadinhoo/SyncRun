import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:frontend/features/onboarding/screens/start_date_screen.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔔 Suptilna ikona
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color:
                    isDark
                        ? Colors.grey[900]
                        : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(
                  Icons.notifications_active,
                  size: 40,
                  color: Color(0xFFFFC366),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 🗣️ Tekst
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "You're ",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  color:
                      isDark ? Colors.white : Colors.black,
                ),
                children: const [
                  TextSpan(
                    text: "3x more likely ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFC366),
                    ),
                  ),
                  TextSpan(
                    text: "to finish your plan\nwith ",
                  ),
                  TextSpan(
                    text: "workout reminders",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFC366),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Runners that opt into notifications are more likely to stick to their plan.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color:
                    isDark
                        ? Colors.grey[400]
                        : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 36),

            // 🔘 Switch
            const NotificationToggle(),

            const SizedBox(height: 24),

            // ✅ Dugme odmah ispod switcha, elegantnije
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const StartDateScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC366),
                  minimumSize: const Size.fromHeight(44),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationToggle extends ConsumerStatefulWidget {
  const NotificationToggle({super.key});

  @override
  ConsumerState<NotificationToggle> createState() =>
      _NotificationToggleState();
}

class _NotificationToggleState
    extends ConsumerState<NotificationToggle> {
  bool isEnabled = true;

  @override
  void initState() {
    super.initState();
    final onboarding = ref.read(onboardingAnswersProvider);
    isEnabled = onboarding.notificationsEnabled ?? true;
  }

  void _toggle(bool value) {
    setState(() => isEnabled = value);
    ref.read(onboardingAnswersProvider.notifier).state = ref
        .read(onboardingAnswersProvider)
        .copyWith(notificationsEnabled: value);
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: isEnabled,
      onChanged: _toggle,
      contentPadding: EdgeInsets.zero,
      title: const Text("Enable notifications"),
      subtitle: const Text(
        "Get reminders for your training days",
      ),
      activeColor: const Color(0xFFFFC366),
    );
  }
}
