import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Exact Design System tokens from Stitch "Nurture & Bloom" (DESIGN.md)
class NurtureBloomColors {
  static const Color surface = Color(0xFFF7FAF5);
  static const Color surfaceDim = Color(0xFFD8DBD6);
  static const Color surfaceBright = Color(0xFFF7FAF5);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF1F4F0);
  static const Color surfaceContainer = Color(0xFFECEFEA);
  static const Color surfaceContainerHigh = Color(0xFFE6E9E4);
  static const Color surfaceContainerHighest = Color(0xFFE0E3DF);

  static const Color onSurface = Color(0xFF191C1A);
  static const Color onSurfaceVariant = Color(0xFF424942);
  static const Color inverseSurface = Color(0xFF2D312E);
  static const Color inverseOnSurface = Color(0xFFEFF2ED);
  static const Color outline = Color(0xFF727972);
  static const Color outlineVariant = Color(0xFFC1C8C0);
  static const Color surfaceTint = Color(0xFF41674C);

  static const Color primary = Color(0xFF3E644A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF567D62);
  static const Color onPrimaryContainer = Color(0xFFF6FFF4);
  static const Color inversePrimary = Color(0xFFA7D1B0);
  static const Color primaryFixed = Color(0xFFC2EDCB);
  static const Color primaryFixedDim = Color(0xFFA7D1B0);
  static const Color onPrimaryFixed = Color(0xFF00210F);
  static const Color onPrimaryFixedVariant = Color(0xFF294E36);

  static const Color secondary = Color(0xFF6B5B50);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFF4DFD0);
  static const Color onSecondaryContainer = Color(0xFF716156);
  static const Color secondaryFixed = Color(0xFFF4DFD0);
  static const Color secondaryFixedDim = Color(0xFFD7C3B5);
  static const Color onSecondaryFixed = Color(0xFF241911);
  static const Color onSecondaryFixedVariant = Color(0xFF52443A);

  static const Color tertiary = Color(0xFF964327);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFB55B3D);
  static const Color onTertiaryContainer = Color(0xFFFFFBFF);
  static const Color tertiaryFixed = Color(0xFFFFDBD0);
  static const Color tertiaryFixedDim = Color(0xFFFFB59E);
  static const Color onTertiaryFixed = Color(0xFF390B00);
  static const Color onTertiaryFixedVariant = Color(0xFF7A2F15);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static List<BoxShadow> get ambientWarmShadow => [
        BoxShadow(
          color: const Color(0xFF2D312E).withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 4),
          spreadRadius: -2,
        ),
      ];
}

class NurtureBloomTextStyles {
  static TextStyle get displayLg => GoogleFonts.plusJakartaSans(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 44 / 36,
        letterSpacing: -0.72,
        color: NurtureBloomColors.onSurface,
      );

  static TextStyle get headlineLgMobile => GoogleFonts.plusJakartaSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 34 / 26,
        letterSpacing: -0.26,
        color: NurtureBloomColors.onSurface,
      );

  static TextStyle get headlineMd => GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 30 / 22,
        letterSpacing: -0.22,
        color: NurtureBloomColors.onSurface,
      );

  static TextStyle get headlineSm => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 26 / 18,
        color: NurtureBloomColors.onSurface,
      );

  static TextStyle get bodyLg => GoogleFonts.plusJakartaSans(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 26 / 17,
        color: NurtureBloomColors.onSurface,
      );

  static TextStyle get bodyMd => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 23 / 15,
        color: NurtureBloomColors.onSurface,
      );

  static TextStyle get bodySm => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 19 / 13,
        color: NurtureBloomColors.onSurfaceVariant,
      );

  static TextStyle get labelLg => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 20 / 15,
        color: NurtureBloomColors.onSurface,
      );

  static TextStyle get labelMd => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 18 / 13,
        color: NurtureBloomColors.onSurface,
      );

  static TextStyle get labelSm => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 16 / 11,
        letterSpacing: 0.22,
        color: NurtureBloomColors.onSurfaceVariant,
      );
}

class NurtureBloomTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: NurtureBloomColors.surface,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: NurtureBloomColors.primary,
        onPrimary: NurtureBloomColors.onPrimary,
        primaryContainer: NurtureBloomColors.primaryFixed,
        onPrimaryContainer: NurtureBloomColors.onPrimaryFixed,
        secondary: NurtureBloomColors.secondary,
        onSecondary: NurtureBloomColors.onSecondary,
        secondaryContainer: NurtureBloomColors.secondaryFixed,
        onSecondaryContainer: NurtureBloomColors.onSecondaryFixed,
        tertiary: NurtureBloomColors.tertiary,
        onTertiary: NurtureBloomColors.onTertiary,
        tertiaryContainer: NurtureBloomColors.tertiaryFixed,
        onTertiaryContainer: NurtureBloomColors.onTertiaryFixed,
        error: NurtureBloomColors.error,
        onError: NurtureBloomColors.onError,
        surface: NurtureBloomColors.surface,
        onSurface: NurtureBloomColors.onSurface,
      ),
      textTheme: baseTextTheme,
      cardTheme: CardThemeData(
        color: NurtureBloomColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
