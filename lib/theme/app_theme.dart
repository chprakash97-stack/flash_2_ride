import 'package:flutter/material.dart';

class AppTheme {
  static const Color mainBlue = Color(0xFF0645D8);
  static const Color darkBlue = Color(0xFF062B9C);
  static const Color brightBlue = Color(0xFF0878F9);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color brandYellow = Color(0xFFFFD21C);

  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color borderGrey = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textGrey = Color(0xFF64748B);

  static const Color brandPurple = mainBlue;
  static const Color brandPurpleLight = brightBlue;
  static const Color primaryGreen = mainBlue;
  static const Color cardBlack = cardWhite;
  static const Color backgroundBlack = backgroundLight;
  static const Color textWhite = textDark;
  static const Color textBlack = textDark;

  static ThemeData get lightTheme => masterTheme;

  static ThemeData get masterTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      primaryColor: mainBlue,
      colorScheme: const ColorScheme.light(
        primary: mainBlue,
        secondary: brandYellow,
        surface: cardWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cardWhite,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: IconThemeData(color: mainBlue),
        titleTextStyle: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }
}
