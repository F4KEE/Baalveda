import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Pure Web Brand Palette
  static const Color primaryNavy = Color(0xFF1A2D7F);     // True brand text/navy indigo
  static const Color accentRose = Color(0xFFEF4A64);      // True website warm rose
  static const Color bgCleanWhite = Color(0xFFFBFBFD);    // High-end medical light workspace
  static const Color surfacePure = Color(0xFFFFFFFF);
  
  // Editorial Typography & UI Elements
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color borderMuted = Color(0xFFE5E7EB);
  
  static const Color semanticSuccess = Color(0xFF10B981);
  static const Color semanticWarning = Color(0xFFF59E0B);

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryNavy,
      scaffoldBackgroundColor: bgCleanWhite,
      colorScheme: const ColorScheme.light(
        primary: primaryNavy,
        secondary: accentRose,
        surface: surfacePure,
        error: Color(0xFFDC2626),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
      ),
      cardTheme: CardThemeData(
        color: surfacePure,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderMuted, width: 1),
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        displayMedium: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w700, color: primaryNavy, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w700, color: primaryNavy, letterSpacing: -0.25),
        titleLarge: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: textDark),
        titleMedium: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: textDark),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 15, color: textMedium, height: 1.5),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 13, color: textMedium, height: 1.5),
        labelLarge: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: primaryNavy),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderMuted, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderMuted, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryNavy, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textLight, fontSize: 14),
        prefixIconColor: textLight,
        suffixIconColor: textLight,
      ),
    );
  }

  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;

  static List<BoxShadow> get premiumShadow => [
        BoxShadow(
          color: const Color(0xFF1A2D7F).withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];
}