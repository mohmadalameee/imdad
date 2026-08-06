import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final Color primaryColor = const Color(0xFF1A5F7A);
  static final Color secondaryColor = const Color(0xFFF5C842);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.grey[50],
    textTheme: GoogleFonts.tajawalTextTheme(), // خط Tajawal من Google Fonts
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: const Color(0xFFE8F4F8),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFF1A5F7A),
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF2B7A8C),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: GoogleFonts.tajawalTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2B7A8C),
      brightness: Brightness.dark,
      primary: const Color(0xFF2B7A8C),
      secondary: secondaryColor,
      tertiary: const Color(0xFF1E3A45),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFF1A2E35),
      foregroundColor: Colors.white,
    ),
  );
}
