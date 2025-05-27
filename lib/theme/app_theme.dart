import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF0A4543);
  static const Color grayColor = Color(0xFFB3B3B3);
  static const Color borderColor = Color(0xFFD9D9D9);
  static const Color yellowColor = Color(0xFFF5C000);
  static const Color redColor = Color(0xFFF98380);
  static const Color whiteColor = Colors.white;
  static const Color backgroundColor = Color(0xFFF6F9F8);
  static const Color greenLocationColor = Color(0xFF2A9885);
  static const Color hintTextColor = Color(0xFF717680);

  // --- Custom text styles ---
  static TextStyle get font12Regular => GoogleFonts.changa(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle get font14Regular => GoogleFonts.changa(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle get font15SemiBold => GoogleFonts.changa(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 32 / 15,
  );

  static TextStyle get font13RegularGray => GoogleFonts.changa(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: grayColor,
  );
  static TextStyle get font14LightHint => GoogleFonts.changa(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 20 / 14,
    color: hintTextColor,
  );
  static TextStyle get font24Bold => GoogleFonts.changa(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
  );
  static TextStyle get font14Medium => GoogleFonts.changa(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 26 / 14,
  );

  static TextStyle get font20SemiBold => GoogleFonts.changa(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  height: 28 / 20,
  color: primaryColor,
);

  static ThemeData get lightTheme => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: GoogleFonts.changaTextTheme().copyWith(
      bodyLarge: GoogleFonts.changa(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 26 / 18,
      ),
      bodyMedium: GoogleFonts.changa(fontSize: 24, fontWeight: FontWeight.w500),
      bodySmall: GoogleFonts.changa(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      titleLarge: GoogleFonts.changa(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
      ),
    ),
  );
}
