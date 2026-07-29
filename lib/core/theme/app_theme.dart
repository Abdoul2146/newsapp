import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/flavor_config.dart';

class AppTheme {
  static Color get primaryColor => FlavorConfig.instance.primaryColor;
  static Color get secondaryColor => FlavorConfig.instance.secondaryColor;

  static ThemeData get lightTheme {
    final config = FlavorConfig.instance;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: config.primaryColor,
        primary: config.primaryColor,
        secondary: config.secondaryColor,
        surface: Colors.white,
        background: const Color(0xFFF8F9FA),
      ),
      textTheme: GoogleFonts.getTextTheme(config.fontFamily),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: config.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    final config = FlavorConfig.instance;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: config.primaryColor,
        brightness: Brightness.dark,
        primary: config.flavor == AppFlavor.us
            ? const Color(0xFF9FA8DA)
            : config.primaryColor.withOpacity(0.8),
        secondary: config.secondaryColor,
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
      ),
      textTheme: GoogleFonts.getTextTheme(
        config.fontFamily,
        ThemeData.dark().textTheme,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.white,
      ),
    );
  }
}
