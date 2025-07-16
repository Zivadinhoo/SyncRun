import 'package:flutter/material.dart';

final lightColorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFF6C144), // Sunflower Yellow
  onPrimary: Colors.black,
  secondary: Color(
    0xFFFFE8A3,
  ), // Warm, deeper pastel yellow for AppBar
  onSecondary: Colors.black,
  surface: Colors.white,
  onSurface: Color(0xFF1C1C1E),
  error: Colors.red,
  onError: Colors.white,
);

final darkColorScheme = const ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFF3B0),
  onPrimary: Colors.black,
  secondary: Color(0xFFFFF9DB),
  onSecondary: Colors.black,
  surface: Colors.black,
  onSurface: Colors.white,
  error: Colors.red,
  onError: Colors.white,
);

ThemeData getLightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: const Color(
      0xFFFFFCF5,
    ), // almost white
    appBarTheme: AppBarTheme(
      backgroundColor:
          lightColorScheme.secondary, // soft yellow
      foregroundColor: Colors.black,
      centerTitle: true,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: const Border(
        bottom: BorderSide(
          color: Color(0xFFE0E0E0), // subtle bottom border
          width: 1,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardColor: Colors.white,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );
}

ThemeData getDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: const Color(0xFF1C1C1E),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: const Color(0xFF1C1C1E),
      foregroundColor: darkColorScheme.onSurface,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardColor: const Color(0xFF2C2C2E),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}
