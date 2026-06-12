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
      case 'red':
        return _buildTheme(
          background: const Color(0xFF120808),
          primary: const Color(0xFFE53935),
          secondary: const Color(0xFFB71C1C),
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
        surface: background,
      ),
      cardColor: background.withOpacity(0.6),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        indicatorColor: primary.withOpacity(0.15),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        thumbColor: primary,
        overlayColor: primary.withOpacity(0.2),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected) ? primary : Colors.white38,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? primary.withOpacity(0.4)
              : Colors.white12,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
    );
  }
}
