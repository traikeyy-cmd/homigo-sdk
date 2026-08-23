import 'package:flutter/material.dart';

/// معلومات Insets الحالية للشاشة.
///
/// تشمل:
/// - Status bar / cutouts
/// - Gesture navigation / navigation bar
/// - Keyboard / IME
@immutable
class HomiGoInsetsData {
  final EdgeInsets padding;
  final EdgeInsets viewPadding;
  final EdgeInsets viewInsets;

  const HomiGoInsetsData({
    required this.padding,
    required this.viewPadding,
    required this.viewInsets,
  });

  double get top => padding.top;

  double get bottom => padding.bottom;

  double get left => padding.left;

  double get right => padding.right;

  double get keyboardBottom => viewInsets.bottom;

  bool get keyboardVisible => viewInsets.bottom > 0;

  bool get hasTopInset => viewPadding.top > 0;

  bool get hasBottomInset => viewPadding.bottom > 0;
}

abstract final class HomiGoInsets {
  static HomiGoInsetsData of(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return HomiGoInsetsData(
      padding: mediaQuery.padding,
      viewPadding: mediaQuery.viewPadding,
      viewInsets: mediaQuery.viewInsets,
    );
  }

  static EdgeInsets systemPadding(BuildContext context) {
    return MediaQuery.paddingOf(context);
  }

  static EdgeInsets keyboardInsets(BuildContext context) {
    return MediaQuery.viewInsetsOf(context);
  }

  static EdgeInsets persistentSystemPadding(BuildContext context) {
    return MediaQuery.viewPaddingOf(context);
  }
}

/// SafeArea موحد للـSDK.
class HomiGoSafeArea extends StatelessWidget {
  final Widget child;

  final bool left;
  final bool top;
  final bool right;
  final bool bottom;

  final EdgeInsets minimum;

  final bool maintainBottomViewPadding;

  const HomiGoSafeArea({
    super.key,
    required this.child,
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      minimum: minimum,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: child,
    );
  }
}

/// يعالج فتح وإغلاق لوحة المفاتيح بدون إخفاء المحتوى.
class HomiGoKeyboardInsets extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry padding;

  final Duration duration;
  final Curve curve;

  final bool includeBottomSystemInset;

  const HomiGoKeyboardInsets({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.duration = const Duration(milliseconds: 220),
    this.curve = Curves.easeOutCubic,
    this.includeBottomSystemInset = false,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final keyboardBottom = mediaQuery.viewInsets.bottom;

    final systemBottom = includeBottomSystemInset
        ? mediaQuery.viewPadding.bottom
        : 0.0;

    return AnimatedPadding(
      duration: duration,
      curve: curve,
      padding: EdgeInsets.only(
        bottom: keyboardBottom + systemBottom,
      ).add(padding.resolve(Directionality.of(context))),
      child: child,
    );
  }
}
