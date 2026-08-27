import 'package:flutter/material.dart';

/// Elevation tokens الرسمية في HomiGo Design System.
///
/// تحتوي على قيم الظلال فقط.
/// لون الظل نفسه يحدد حسب Light/Dark أو لون الـAccent.
abstract final class HomiGoElevation {
  static const double none = 0;

  // Cards / Surfaces
  static const double cardBlur = 12;
  static const Offset cardOffset = Offset(0, 4);
  static const double cardOpacityLight = 0.055;
  static const double cardOpacityDark = 0.22;

  // Elevated icons
  static const double iconPrimaryBlur = 12;
  static const Offset iconPrimaryOffset = Offset(0, 6);
  static const double iconPrimaryOpacity = 0.22;

  static const double iconSecondaryBlur = 4;
  static const Offset iconSecondaryOffset = Offset(0, 2);
  static const double iconSecondaryOpacity = 0.06;

  // Selected controls
  static const double selectedBlur = 8;
  static const Offset selectedOffset = Offset(0, 2);
  static const double selectedOpacity = 0.18;
}
