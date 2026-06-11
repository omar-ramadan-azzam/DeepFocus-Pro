import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData getTheme(String themeName) {
    switch (themeName) {
      case 'forest':
        return _buildTheme(
          background: const Color(0xFF07110B),
          primary: const Color(0xFF4CAF50),
          secondary: const Color(0xFF388E3C),
        );
      case 'ocean':
        return _buildTheme(
          background: const Color(0xFF08121B),
          primary: const Color(0xFF4DA3FF),
          secondary: const Color(0xFF1565C0),
        );
      case 'purple':
        return _buildTheme(
          background: const Color(0xFF0E0815),
          primary: const Color(0xFFA855F7),
          secondary: const Color(0xFF7B1FA2),
        );
      case 'amoled':
        return _buildTheme(
          background: const Color(0xFF000000),
          primary: const Color(0xFFF0A028),
          secondary: const Color(0xFFD46A0F),
        );
      default:
        return _buildTheme(
          background: const Color(0xFF08090D),
          primary: const Color(0xFFF0A028),
          secondary: const Color(0xFFD46A0F),
        );
    }
  }

  static ThemeData _buildTheme({
    required Color background,
    required Color primary,
    required Color secondary,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.dark(
        background: background,
        primary: primary,
        secondary: secondary,
        surface: background.withOpacity(0.8),
      ),
      cardColor: background.withOpacity(0.6),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: primary,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
    );
  }
}
