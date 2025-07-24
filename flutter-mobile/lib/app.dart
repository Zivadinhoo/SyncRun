import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/router.dart';
import 'package:frontend/theme/theme.dart';

class SyncRunApp extends ConsumerWidget {
  const SyncRunApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'SyncRun',
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      themeMode: ThemeMode.system,
      theme: getLightTheme(),
      darkTheme: getDarkTheme(),
    );
  }
}
