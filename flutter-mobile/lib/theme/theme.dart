import 'package:flutter/material.dart';

final lightColorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFF6C144), // Sunflower Yellow
  onPrimary: Colors.black,
  secondary: Color(0xFFFFF5D5),
  onSecondary: Colors.black,
  surface: Colors.white,
  onSurface: Color(0xFF1C1C1E),
  error: Colors.red,
  onError: Colors.white,
);

final darkColorScheme = const ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFF3B0), // ista žuta za konzistentnost
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
    ), // background koja odgovara boji
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFCF5),
      foregroundColor: Colors.black,
      centerTitle: true,
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
  );
}
