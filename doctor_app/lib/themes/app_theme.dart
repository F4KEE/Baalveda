import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Color Palette (Synchronized with web booking assets)
  static const Color primaryBlue = Color(0xFF1A2D7F);      // True brand text/navy indigo
  static const Color accentPink = Color(0xFFEF4A64);       // True website warm rose
  static const Color backgroundLight = Color(0xFFF6F7FA);   // High-end workspace light gray base
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  
  // Alternative Design Tokens to support complete reverse compatibility
  static const Color primaryNavy = Color(0xFF1A2D7F);     
  static const Color accentRose = Color(0xFFEF4A64);      
  static const Color bgCleanWhite = Color(0xFFFBFBFD);    
  static const Color surfacePure = Color(0xFFFFFFFF);

  // Editorial Typography & UI Elements
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color dividerColor = Color(0xFFE5E7EB);
  static const Color borderMuted = Color(0xFFE5E7EB);
  
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color semanticSuccess = Color(0xFF10B981);
  static const Color semanticWarning = Color(0xFFF59E0B);

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: accentPink,
        surface: surfaceWhite,
        error: Color(0xFFDC2626),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
      ),
      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: dividerColor, width: 1),
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        displayMedium: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w700, color: primaryBlue, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w700, color: primaryBlue, letterSpacing: -0.25),
        headlineSmall: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w600, color: textDark),
        titleLarge: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: textDark),
        titleMedium: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: textDark),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16, color: textMedium, height: 1.5),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, color: textMedium, height: 1.5),
        bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, color: textLight, height: 1.4),
        labelLarge: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: primaryBlue),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textLight, fontSize: 14),
        prefixIconColor: textLight,
        suffixIconColor: textLight,
      ),
    );
  }

  // Spacing Tokens
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing6 = 6;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;

  // Border Radius Tokens
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXL = 20;

  // Shadows
  static const BoxShadow shadowSmall = BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.04), blurRadius: 8, offset: Offset(0, 2));
  static const BoxShadow shadowMedium = BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 16, offset: Offset(0, 4));
  static List<BoxShadow> get shadowsSmall => [shadowSmall];
  static List<BoxShadow> get shadowsMedium => [shadowMedium];
  static List<BoxShadow> get premiumShadow => [shadowSmall];
}