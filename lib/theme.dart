import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoenixTheme {
  static const Color primary = Color(0xFFFF6B00); // More vibrant Phoenix Orange
  static const Color secondary = Color(0xFFFF2D00); // Phoenix Red
  static const Color accent = Color(0xFFFFD600); // Phoenix Gold
  static const Color background = Color(0xFF030508);
  static const Color cardBg = Color(0x1AFFFFFF); // Semi-transparent for glass effect
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color border = Color(0x33FFFFFF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: accent,
        surface: background,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: textPrimary),
          bodyMedium: TextStyle(color: textSecondary),
        ),
      ).copyWith(
        titleLarge: GoogleFonts.orbitron(color: primary, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        titleMedium: GoogleFonts.orbitron(color: accent, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.orbitron(color: textPrimary, fontWeight: FontWeight.w900),
      ),
    );
  }

  static BoxDecoration glassDecoration({double blur = 10.0, double opacity = 0.1}) {
    return BoxDecoration(
      color: Colors.white.withOpacity(opacity),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withOpacity(0.1)),
    );
  }
}
