import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF00B368);
  static const Color darkGreen = Color(0xFF008A4F);
  static const Color backgroundWhite = Color(0xFFF8FAFC); // Eye-comfort soft background
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color borderGrey = Color(0xFFE2E8F0);
  static const Color textBlack = Color(0xFF0F172A); // Ultra-crisp high-contrast text
  static const Color textGrey = Color(0xFF475569);
  static const Color flashYellow = Color(0xFFFFC107);

  // Aliases for full backward compatibility
  static const Color cardBlack = Color(0xFFFFFFFF);
  static const Color backgroundBlack = Color(0xFFF8FAFC);
  static const Color textWhite = Color(0xFF0F172A);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundWhite,
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: primaryGreen,
        surface: cardWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cardWhite,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryGreen),
        titleTextStyle: TextStyle(color: textBlack, fontSize: 19, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 1,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF1F5F9),
        hintStyle: TextStyle(color: textGrey, fontSize: 14),
        prefixIconColor: primaryGreen,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14)), borderSide: BorderSide(color: borderGrey)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14)), borderSide: BorderSide(color: borderGrey)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14)), borderSide: BorderSide(color: primaryGreen, width: 1.5)),
      ),
    );
  }
}
