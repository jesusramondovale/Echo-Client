import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EchoTheme {
  static const _ink = Color(0xFF1A2332);
  static const _sand = Color(0xFFF2EDE4);
  static const _teal = Color(0xFF0F6E6A);
  static const _coral = Color(0xFFC45C3E);

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _teal,
        brightness: Brightness.light,
        primary: _teal,
        secondary: _coral,
        surface: _sand,
      ),
      scaffoldBackgroundColor: _sand,
    );

    return base.copyWith(
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(
        bodyColor: _ink,
        displayColor: _ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _sand,
        foregroundColor: _ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.fraunces(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: _ink,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
