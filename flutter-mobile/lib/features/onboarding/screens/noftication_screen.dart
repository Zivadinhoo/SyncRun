import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/onboarding/providers/onboarding_answers.provider.dart';
import 'package:frontend/features/onboarding/screens/start_date_screen.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true, // 👈 back dugme
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color:
              isDark
                  ? Colors.white
                  : Colors.black, // boja back ikone
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
            // 🛎️ Notification image placeholder
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color:
                    isDark
                        ? Colors.grey[900]
                        : Colors.grey[200],
              ),
              child: Center(
                child: Icon(
                  Icons.notifications_active,
                  size: 80,
                  color:
                      Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 💬 Motivational text
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "You're ",
                style: TextStyle(
                  fontSize: 20,
                  color:
                      isDark ? Colors.white : Colors.black,
                ),
                children: const [
                  TextSpan(
                    text: "3x more likely ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  TextSpan(
                    text: "to finish your plan\nwith ",
                  ),
                  TextSpan(
                    text: "workout reminders",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
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
                color:
                    isDark
                        ? Colors.grey[400]
                        : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 40),

            // 🔘 Switch toggle
            const NotificationToggle(),

            const Spacer(),

            // ▶️ Continue button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StartDateScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text("Continue"),
            ),
            const SizedBox(height: 16),
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
      title: const Text("Enable notifications"),
      subtitle: const Text(
        "Get reminders for your training days",
      ),
    );
  }
}
