import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFF0A4543),
      scaffoldBackgroundColor: const Color(0xFFF6F9F8),
      textTheme: GoogleFonts.changaTextTheme().copyWith(
        // النصوص العريضة (Body Large)
        bodyLarge: GoogleFonts.changa(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 26 / 18, // line-height: 26px
        ),

        // النصوص المتوسطة
        bodyMedium: GoogleFonts.changa(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),

        // العناوين الكبيرة
        titleLarge: GoogleFonts.changa(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          height: 32 / 24, // line-height: 32px
        ),
      ),
    );
  }
}
