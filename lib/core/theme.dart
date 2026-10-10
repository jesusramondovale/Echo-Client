import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EchoColors {
  static const ink = Color(0xFF0B1220);
  static const surface = Color(0xFFF4F6F8);
  static const card = Color(0xFFFFFFFF);
  static const primary = Color(0xFF0A8F8A);
  static const primaryMuted = Color(0xFF147F7A);
  static const secondary = Color(0xFFE8A317);
  static const outline = Color(0x1A0B1220);
  static const muted = Color(0xFF5C6578);

  /// True black for OLED panels.
  static const oledBlack = Color(0xFF000000);
  static const darkCard = Color(0xFF0A0A0A);
  static const darkInk = Color(0xFFF2F4F7);
  static const darkMuted = Color(0xFF9AA3B5);
  static const darkOutline = Color(0x33FFFFFF);

  static bool _dark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color inkOf(BuildContext context) =>
      _dark(context) ? darkInk : ink;

  static Color mutedOf(BuildContext context) =>
      _dark(context) ? darkMuted : muted;

  static Color cardOf(BuildContext context) =>
      _dark(context) ? darkCard : card;

  static Color surfaceOf(BuildContext context) =>
      _dark(context) ? oledBlack : surface;

  static Color outlineOf(BuildContext context) =>
      _dark(context) ? darkOutline : outline;
}

class EchoTheme {
  static const _radius = 20.0;

  static ThemeData light() => _build(
        brightness: Brightness.light,
        ink: EchoColors.ink,
        surface: EchoColors.surface,
        card: EchoColors.card,
        muted: EchoColors.muted,
        outline: EchoColors.outline,
        surfaceContainerHighest: const Color(0xFFE8ECF1),
        dragHandle: const Color(0x330B1220),
        onSecondary: EchoColors.ink,
      );

  static ThemeData darkOled() => _build(
        brightness: Brightness.dark,
        ink: EchoColors.darkInk,
        surface: EchoColors.oledBlack,
        card: EchoColors.darkCard,
        muted: EchoColors.darkMuted,
        outline: EchoColors.darkOutline,
        surfaceContainerHighest: const Color(0xFF121212),
        dragHandle: const Color(0x55FFFFFF),
        onSecondary: EchoColors.ink,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color ink,
    required Color surface,
    required Color card,
    required Color muted,
    required Color outline,
    required Color surfaceContainerHighest,
    required Color dragHandle,
    required Color onSecondary,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: EchoColors.primary,
      onPrimary: Colors.white,
      secondary: EchoColors.secondary,
      onSecondary: onSecondary,
      error: const Color(0xFFC23B3B),
      onError: Colors.white,
      surface: surface,
      onSurface: ink,
      surfaceContainerHighest: surfaceContainerHighest,
      outline: outline,
      outlineVariant: outline,
    );

    final bodyText = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ).apply(
      bodyColor: ink,
      displayColor: ink,
    );

    final display = GoogleFonts.syne(
      color: ink,
      fontWeight: FontWeight.w700,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,
      textTheme: bodyText.copyWith(
        displayLarge: display.copyWith(fontSize: 48, height: 1.05),
        displayMedium: display.copyWith(fontSize: 36, height: 1.1),
        displaySmall: display.copyWith(fontSize: 28, height: 1.15),
        headlineMedium: display.copyWith(fontSize: 24, height: 1.2),
        titleLarge: display.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: display.copyWith(fontSize: 26),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: BorderSide(color: outline),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        elevation: 0,
        height: 72,
        indicatorColor: EchoColors.primary.withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? EchoColors.primary : muted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? EchoColors.primary : muted,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: EchoColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        extendedTextStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: EchoColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: BorderSide(color: outline),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        hintStyle: GoogleFonts.plusJakartaSans(color: muted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: EchoColors.primary, width: 1.5),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: outline,
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: dragHandle,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        titleTextStyle: display.copyWith(fontSize: 20),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: EchoColors.primary.withValues(alpha: 0.1),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: EchoColors.primaryMuted,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        subtitleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          height: 1.35,
          color: muted,
        ),
        iconColor: EchoColors.primary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return EchoColors.primary;
          return muted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return EchoColors.primary.withValues(alpha: 0.35);
          }
          return outline;
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: EchoColors.primary,
      ),
    );
  }
}
