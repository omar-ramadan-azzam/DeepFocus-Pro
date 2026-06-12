import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData getTheme(String themeName) {
    switch (themeName) {
      case 'forest':
        return _buildTheme(
          background: const Color(0xFF0A1628),
          primary: const Color(0xFF00C853),
          secondary: const Color(0xFF00E676),
          cardColor: const Color(0xFF0D1F3C),
        );
      case 'ocean':
        return _buildTheme(
          background: const Color(0xFF08121B),
          primary: const Color(0xFF4DA3FF),
          secondary: const Color(0xFF1565C0),
          cardColor: const Color(0xFF0D1F2D),
        );
      case 'purple':
        return _buildTheme(
          background: const Color(0xFF0E0815),
          primary: const Color(0xFFA855F7),
          secondary: const Color(0xFF7B1FA2),
          cardColor: const Color(0xFF1A0D2E),
        );
      case 'gold':
        return _buildTheme(
          background: const Color(0xFF08090D),
          primary: const Color(0xFFF0A028),
          secondary: const Color(0xFFD46A0F),
          cardColor: const Color(0xFF12110A),
        );
      case 'amoled':
        return _buildTheme(
          background: const Color(0xFF000000),
          primary: const Color(0xFF00E5FF),
          secondary: const Color(0xFF00B8D4),
          cardColor: const Color(0xFF0A0A0A),
        );
      case 'red':
        return _buildTheme(
          background: const Color(0xFF120808),
          primary: const Color(0xFFE53935),
          secondary: const Color(0xFFB71C1C),
          cardColor: const Color(0xFF1A0A0A),
        );
      case 'sunset':
        return _buildTheme(
          background: const Color(0xFF0D0A1A),
          primary: const Color(0xFFFF6B35),
          secondary: const Color(0xFFFF8C00),
          cardColor: const Color(0xFF1A0D15),
        );
      default: // teal - الثيم الأساسي الأخضر المزرق
        return _buildTheme(
          background: const Color(0xFF0A1628),
          primary: const Color(0xFF00BFA5),
          secondary: const Color(0xFF00E5CC),
          cardColor: const Color(0xFF0D1F3C),
        );
    }
  }

  static ThemeData _buildTheme({
    required Color background,
    required Color primary,
    required Color secondary,
    required Color cardColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.dark(
        background: background,
        primary: primary,
        secondary: secondary,
        surface: cardColor,
      ),
      cardColor: cardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
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
        inactiveTrackColor: Colors.white12,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? primary
              : Colors.white38,
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
