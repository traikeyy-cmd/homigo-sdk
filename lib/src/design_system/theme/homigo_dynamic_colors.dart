import 'package:flutter/material.dart';

/// Resolves HomiGo runtime colors from the host application's active theme.
///
/// This makes HomiGo components automatically follow Material dynamic colors,
/// custom ColorSchemes, and light/dark theme changes. Brand colors remain the
/// seed/fallback used when building a HomiGo theme, while rendered components
/// use the active [ColorScheme] from [BuildContext].
abstract final class HomiGoDynamicColors {
  static Color primary(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color secondary(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color onSurface(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;
}
