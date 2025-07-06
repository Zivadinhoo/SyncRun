import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/athlete/services/noftication_service.dart';
import 'package:frontend/router.dart'; // 👈 dodaj svoj router fajl
import 'package:frontend/features/common/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize(); // 👈 Inicijalizuj notifikacije

  runApp(const ProviderScope(child: RunWithCoachApp()));
}

class RunWithCoachApp extends ConsumerWidget {
  const RunWithCoachApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'RunWithCoach',
      themeMode: themeMode,
      routerConfig: router, // 👈 koristiš GoRouter

      theme: ThemeData(
        primaryColor: const Color(0xFFFFB74D),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFFCC80),
          secondary: Color(0xFFFFCC80),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF3E0),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),

      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFFFA726),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFA726),
          secondary: Color(0xFFFFCC80),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
    );
  }
}
