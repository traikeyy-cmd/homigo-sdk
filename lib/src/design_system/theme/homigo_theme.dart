import 'package:flutter/material.dart';

import '../../core/config/homigo_brand.dart';
import '../../core/config/homigo_sdk_core.dart';
import '../tokens/homigo_colors.dart';
import '../tokens/homigo_typography.dart';

/// المحرك المركزي لثيم HomiGo SDK.
///
/// يستخدم هوية التطبيق الموجودة في [HomiGoSDK.config]
/// مع إمكانية تمرير Brand مختلف عند الحاجة.
abstract final class HomiGoTheme {
  /// الثيم الفاتح.
  static ThemeData light({HomiGoBrand? brand, ColorScheme? colorScheme}) {
    final effectiveBrand = brand ?? HomiGoSDK.config.brand;

    return _buildTheme(
      brightness: Brightness.light,
      brand: effectiveBrand,
      colorScheme: colorScheme,
    );
  }

  /// الثيم الداكن.
  static ThemeData dark({HomiGoBrand? brand, ColorScheme? colorScheme}) {
    final effectiveBrand = brand ?? HomiGoSDK.config.brand;

    return _buildTheme(
      brightness: Brightness.dark,
      brand: effectiveBrand,
      colorScheme: colorScheme,
    );
  }

  /// Builds a HomiGo theme around an existing host [ColorScheme].
  ///
  /// This is the preferred integration point for Material dynamic colors.
  static ThemeData fromColorScheme(
    ColorScheme colorScheme, {
    HomiGoBrand? brand,
  }) {
    final effectiveBrand = brand ?? HomiGoSDK.config.brand;

    return _buildTheme(
      brightness: colorScheme.brightness,
      brand: effectiveBrand,
      colorScheme: colorScheme,
    );
  }

  /// ThemeMode المحدد في إعدادات الـSDK.
  static ThemeMode get mode => HomiGoSDK.config.themeMode;

  static ThemeData _buildTheme({
    required Brightness brightness,
    required HomiGoBrand brand,
    ColorScheme? colorScheme,
  }) {
    final isDark = brightness == Brightness.dark;

    final background = isDark
        ? HomiGoColors.darkBackground
        : HomiGoColors.lightBackground;

    final surface = isDark
        ? HomiGoColors.darkSurface
        : HomiGoColors.lightSurface;

    final textPrimary = isDark
        ? HomiGoColors.darkTextPrimary
        : HomiGoColors.lightTextPrimary;

    final textSecondary = isDark
        ? HomiGoColors.darkTextSecondary
        : HomiGoColors.lightTextSecondary;

    final border = isDark ? HomiGoColors.darkBorder : HomiGoColors.lightBorder;

    final effectiveColorScheme =
        colorScheme ??
        ColorScheme.fromSeed(
          seedColor: brand.primaryColor,
          brightness: brightness,
        ).copyWith(
          primary: brand.primaryColor,
          secondary: brand.secondaryColor,
          surface: surface,
          error: HomiGoColors.error,
        );

    final effectiveBackground = colorScheme == null
        ? background
        : effectiveColorScheme.surface;
    final effectiveSurface = effectiveColorScheme.surface;
    final effectiveTextPrimary = colorScheme == null
        ? textPrimary
        : effectiveColorScheme.onSurface;
    final effectiveTextSecondary = colorScheme == null
        ? textSecondary
        : effectiveColorScheme.onSurfaceVariant;
    final effectiveBorder = colorScheme == null
        ? border
        : effectiveColorScheme.outlineVariant;

    final textTheme = TextTheme(
      displayLarge: HomiGoTypography.displayLarge.copyWith(
        color: effectiveTextPrimary,
      ),
      displayMedium: HomiGoTypography.displayMedium.copyWith(
        color: effectiveTextPrimary,
      ),
      headlineLarge: HomiGoTypography.headlineLarge.copyWith(
        color: effectiveTextPrimary,
      ),
      headlineMedium: HomiGoTypography.headlineMedium.copyWith(
        color: effectiveTextPrimary,
      ),
      titleLarge: HomiGoTypography.titleLarge.copyWith(
        color: effectiveTextPrimary,
      ),
      titleMedium: HomiGoTypography.titleMedium.copyWith(
        color: effectiveTextPrimary,
      ),
      bodyLarge: HomiGoTypography.bodyLarge.copyWith(
        color: effectiveTextPrimary,
      ),
      bodyMedium: HomiGoTypography.bodyMedium.copyWith(
        color: effectiveTextPrimary,
      ),
      bodySmall: HomiGoTypography.bodySmall.copyWith(
        color: effectiveTextSecondary,
      ),
      labelLarge: HomiGoTypography.labelLarge.copyWith(
        color: effectiveTextPrimary,
      ),
      labelMedium: HomiGoTypography.labelMedium.copyWith(
        color: effectiveTextSecondary,
      ),
    );

    final radius = BorderRadius.circular(brand.borderRadius);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: effectiveColorScheme,
      scaffoldBackgroundColor: effectiveBackground,
      fontFamily: brand.fontFamily,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: effectiveTextPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: effectiveSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: effectiveBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: effectiveColorScheme.primary,
          foregroundColor: effectiveColorScheme.onPrimary,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: HomiGoTypography.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: effectiveColorScheme.primary,
          foregroundColor: effectiveColorScheme.onPrimary,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: HomiGoTypography.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          foregroundColor: effectiveColorScheme.primary,
          side: BorderSide(color: effectiveBorder),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: HomiGoTypography.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: effectiveSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: effectiveBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: effectiveBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: effectiveColorScheme.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: effectiveColorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: effectiveColorScheme.error,
            width: 1.5,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: effectiveBorder,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        elevation: 0,
        backgroundColor: effectiveSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 0,
        backgroundColor: effectiveSurface,
        modalBackgroundColor: effectiveSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(brand.borderRadius),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: effectiveSurface,
        indicatorColor: effectiveColorScheme.primary.withValues(alpha: 0.14),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: effectiveColorScheme.primary,
        foregroundColor: effectiveColorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: effectiveColorScheme.primary,
      ),
    );
  }
}
