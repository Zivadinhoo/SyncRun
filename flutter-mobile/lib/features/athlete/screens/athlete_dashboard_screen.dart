import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/router.dart'; // zbog isLoggedInProvider

class AthleteDashboardScreen extends ConsumerWidget {
  const AthleteDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Athlete Dashboard"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            const storage = FlutterSecureStorage();
            await storage.deleteAll();

            print('✅ Logout: token obrisan');

            // 🔄 Refresh auth stanje
            ref.invalidate(isLoggedInProvider);

            // ⛳️ Vodi nazad na login
            if (context.mounted) {
              context.go('/login');
            }
          },
          child: const Text("Logout"),
        ),
      ),
    );
  }
}
