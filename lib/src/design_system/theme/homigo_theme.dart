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
  static ThemeData light({HomiGoBrand? brand}) {
    final effectiveBrand = brand ?? HomiGoSDK.config.brand;

    return _buildTheme(brightness: Brightness.light, brand: effectiveBrand);
  }

  /// الثيم الداكن.
  static ThemeData dark({HomiGoBrand? brand}) {
    final effectiveBrand = brand ?? HomiGoSDK.config.brand;

    return _buildTheme(brightness: Brightness.dark, brand: effectiveBrand);
  }

  /// ThemeMode المحدد في إعدادات الـSDK.
  static ThemeMode get mode => HomiGoSDK.config.themeMode;

  static ThemeData _buildTheme({
    required Brightness brightness,
    required HomiGoBrand brand,
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

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: brand.primaryColor,
          brightness: brightness,
        ).copyWith(
          primary: brand.primaryColor,
          secondary: brand.secondaryColor,
          surface: surface,
          error: HomiGoColors.error,
        );

    final textTheme = TextTheme(
      displayLarge: HomiGoTypography.displayLarge.copyWith(color: textPrimary),
      displayMedium: HomiGoTypography.displayMedium.copyWith(
        color: textPrimary,
      ),
      headlineLarge: HomiGoTypography.headlineLarge.copyWith(
        color: textPrimary,
      ),
      headlineMedium: HomiGoTypography.headlineMedium.copyWith(
        color: textPrimary,
      ),
      titleLarge: HomiGoTypography.titleLarge.copyWith(color: textPrimary),
      titleMedium: HomiGoTypography.titleMedium.copyWith(color: textPrimary),
      bodyLarge: HomiGoTypography.bodyLarge.copyWith(color: textPrimary),
      bodyMedium: HomiGoTypography.bodyMedium.copyWith(color: textPrimary),
      bodySmall: HomiGoTypography.bodySmall.copyWith(color: textSecondary),
      labelLarge: HomiGoTypography.labelLarge.copyWith(color: textPrimary),
      labelMedium: HomiGoTypography.labelMedium.copyWith(color: textSecondary),
    );

    final radius = BorderRadius.circular(brand.borderRadius);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: brand.fontFamily,
      textTheme: textTheme,

      // --------------------------------------------------------
      // AppBar
      // --------------------------------------------------------
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
      ),

      // --------------------------------------------------------
      // Cards
      // --------------------------------------------------------
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: border),
        ),
      ),

      // --------------------------------------------------------
      // Elevated Buttons
      // --------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: brand.primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: HomiGoTypography.labelLarge,
        ),
      ),

      // --------------------------------------------------------
      // Filled Buttons
      // --------------------------------------------------------
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: HomiGoTypography.labelLarge,
        ),
      ),

      // --------------------------------------------------------
      // Outlined Buttons
      // --------------------------------------------------------
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          foregroundColor: brand.primaryColor,
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: HomiGoTypography.labelLarge,
        ),
      ),

      // --------------------------------------------------------
      // Inputs
      // --------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: brand.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: HomiGoColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: HomiGoColors.error, width: 1.5),
        ),
      ),

      // --------------------------------------------------------
      // Divider
      // --------------------------------------------------------
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),

      // --------------------------------------------------------
      // Dialog
      // --------------------------------------------------------
      dialogTheme: DialogThemeData(
        elevation: 0,
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),

      // --------------------------------------------------------
      // Bottom Sheet
      // --------------------------------------------------------
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 0,
        backgroundColor: surface,
        modalBackgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(brand.borderRadius),
          ),
        ),
      ),

      // --------------------------------------------------------
      // Navigation Bar
      // --------------------------------------------------------
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: surface,
        indicatorColor: brand.primaryColor.withValues(alpha: 0.14),
      ),

      // --------------------------------------------------------
      // Floating Action Button
      // --------------------------------------------------------
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: brand.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),

      // --------------------------------------------------------
      // Checkbox
      // --------------------------------------------------------
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),

      // --------------------------------------------------------
      // Progress
      // --------------------------------------------------------
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: brand.primaryColor,
      ),
    );
  }
}
