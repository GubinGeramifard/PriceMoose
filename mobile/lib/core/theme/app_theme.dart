import 'package:flutter/material.dart';

class AppTheme {
  static const _green       = Color(0xFF2E7D32); // forest green — primary
  static const _greenLight  = Color(0xFF43A047); // lighter green — accents
  static const _surface     = Color(0xFFF1F8F1); // very light green tint for cards
  static const _background  = Color(0xFFFFFFFF);

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: _green,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFC8E6C9),
      onPrimaryContainer: const Color(0xFF003300),
      secondary: _greenLight,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFDCEDC8),
      onSecondaryContainer: const Color(0xFF1B3A1E),
      tertiary: const Color(0xFF00796B),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFB2DFDB),
      onTertiaryContainer: const Color(0xFF00251E),
      error: const Color(0xFFB00020),
      onError: Colors.white,
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF410002),
      surface: _background,
      onSurface: const Color(0xFF1A1A1A),
      surfaceContainerHighest: _surface,
      onSurfaceVariant: const Color(0xFF4A4A4A),
      outline: const Color(0xFFBDBDBD),
      shadow: Colors.black,
      inverseSurface: const Color(0xFF1B1B1B),
      onInverseSurface: Colors.white,
      inversePrimary: const Color(0xFF81C784),
      scrim: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: _green,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: 1,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: Color(0xFFE0E0E0)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _green, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFC8E6C9),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(color: _green, fontWeight: FontWeight.w600, fontSize: 12);
        }
        return const TextStyle(color: Color(0xFF757575), fontSize: 12);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: _green);
        }
        return const IconThemeData(color: Color(0xFF757575));
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 0,
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: _surface,
      selectedColor: const Color(0xFFC8E6C9),
      labelStyle: const TextStyle(fontSize: 13),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFEEEEEE),
      thickness: 1,
    ),
    scaffoldBackgroundColor: _background,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _green,
      foregroundColor: Colors.white,
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _green,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
