import 'package:flutter/animation.dart';

/// Motion tokens الرسمية في HomiGo Design System.
///
/// تستخدم لتوحيد سرعة وحركة جميع مكونات الـSDK
/// وأي Widgets خاصة يبنيها التطبيق.
abstract final class HomiGoMotion {
  /// ضغط سريع للأزرار والعناصر التفاعلية.
  static const Duration press = Duration(milliseconds: 120);

  /// انتقال سريع للحالات البسيطة.
  static const Duration fast = Duration(milliseconds: 150);

  /// الانتقال القياسي لمعظم مكونات الواجهة.
  static const Duration standard = Duration(milliseconds: 180);

  /// انتقال هادئ للمحتوى الأكبر.
  static const Duration relaxed = Duration(milliseconds: 220);

  /// الحركة القياسية.
  static const Curve standardCurve = Curves.easeOutCubic;

  /// للحركات القصيرة جدًا.
  static const Curve fastCurve = Curves.easeOut;

  /// دخول العناصر.
  static const Curve enterCurve = Curves.easeOutCubic;

  /// خروج العناصر.
  static const Curve exitCurve = Curves.easeInCubic;

  /// Scale عند الضغط على Card أو Button.
  static const double pressedScale = 0.98;

  /// Scale أخف للعناصر الصغيرة.
  static const double compactPressedScale = 0.975;
}
