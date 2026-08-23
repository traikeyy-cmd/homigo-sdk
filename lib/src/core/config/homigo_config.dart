import 'package:flutter/material.dart';

import '../../design_system/tokens/homigo_colors.dart';
import 'homigo_brand.dart';

enum HomiGoEnvironment { development, staging, production }

/// الإعداد المركزي لأي تطبيق يستخدم HomiGo SDK.
@immutable
class HomiGoConfig {
  final String appName;
  final HomiGoEnvironment environment;

  final HomiGoBrand brand;

  final ThemeMode themeMode;

  final Locale defaultLocale;
  final List<Locale> supportedLocales;

  const HomiGoConfig({
    required this.appName,
    this.environment = HomiGoEnvironment.production,
    this.brand = const HomiGoBrand(
      primaryColor: HomiGoColors.primary,
      secondaryColor: HomiGoColors.secondary,
    ),
    this.themeMode = ThemeMode.system,
    this.defaultLocale = const Locale('ar'),
    this.supportedLocales = const [Locale('ar'), Locale('en')],
  });
}
