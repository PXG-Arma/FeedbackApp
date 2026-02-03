import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoenixTheme {
  static const Color primary = Color(0xFFFF6B00); // Vibrant Phoenix Orange
  static const Color secondary = Color(
    0xFF22C55E,
  ); // Emerald Green (Replaces Burning Red)
  static const Color tertiary = Color(0xFF78350F); // Coffee / Cafe Brown
  static const Color accent = Color(0xFFFFD600); // Phoenix Gold
  static const Color background = Color(0xFF000000); // Pure Black
  static const Color backgroundLight = Color(
    0xFF0F172A,
  ); // Slightly lighter navy
  static const Color cardBg = Color(
    0xCC1E293B,
  ); // Increased opacity (0.8) for better readability
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0x1FFFFFFF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        surface: background,
        onSurface: textPrimary,
      ),
      textTheme:
          GoogleFonts.outfitTextTheme(
            const TextTheme(
              displayLarge: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.bold,
              ),
              displayMedium: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: TextStyle(color: textPrimary),
              bodyMedium: TextStyle(color: textSecondary),
            ),
          ).copyWith(
            titleLarge: GoogleFonts.orbitron(
              color: primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              fontSize: 18,
            ),
            titleMedium: GoogleFonts.orbitron(
              color: accent,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: GoogleFonts.orbitron(
              color: textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
    );
  }

  static BoxDecoration glassDecoration({
    double blur = 10.0,
    double opacity = 0.1,
  }) {
    return BoxDecoration(
      color: Colors.white.withOpacity(opacity),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.white.withOpacity(0.05)),
    );
  }

  static BoxDecoration panelDecoration() {
    return BoxDecoration(
      color: cardBg, // Assuming 'cardBg' is intended for 'panelBg'
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.white.withOpacity(0.05)),
    );
  }
}
