import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/native/homigo_native_surface.dart';
import '../../design_system/tokens/homigo_motion.dart';

/// البطاقة العامة الرسمية في HomiGo Design System.
///
/// لا تفترض نوع المحتوى.
/// يمكن استخدامها لبناء:
/// - بطاقات الطلبات
/// - بطاقات المرضى
/// - بطاقات المشاريع
/// - بطاقات الإحصائيات
/// - مربعات الـDashboard
/// - أي محتوى خاص بالتطبيق
///
/// الشكل والحركة والـLight/Dark تأتي من HomiGo SDK،
/// بينما محتوى البطاقة يحدده التطبيق.
class HomiGoCard extends StatefulWidget {
  final Widget child;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final double? width;
  final double? height;

  final double? borderRadius;

  final Color? backgroundColor;
  final Color? borderColor;

  /// Accent اختياري للبطاقة.
  ///
  /// مفيد لحالات selected أو بطاقات ذات هوية لونية خاصة.
  final Color? tintColor;

  /// قوة الـSolid tint.
  ///
  /// لا يوجد Glass أو Blur.
  final double tintStrength;

  /// الإجراء عند الضغط.
  final VoidCallback? onTap;

  /// هل البطاقة مفعلة.
  final bool enabled;

  /// حالة اختيار البطاقة.
  final bool selected;

  /// هل يظهر Shadow/ارتفاع HomiGo.
  final bool elevated;

  const HomiGoCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.tintColor,
    this.tintStrength = 0.0,
    this.onTap,
    this.enabled = true,
    this.selected = false,
    this.elevated = true,
  }) : assert(tintStrength >= 0 && tintStrength <= 1);

  @override
  State<HomiGoCard> createState() => _HomiGoCardState();
}

class _HomiGoCardState extends State<HomiGoCard> {
  bool _pressed = false;

  bool get _interactive => widget.enabled && widget.onTap != null;

  void _setPressed(bool value) {
    if (_pressed == value || !mounted) {
      return;
    }

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;

    final radius = widget.borderRadius ?? brand.borderRadius;

    Widget card = HomiGoNativeSurface(
      width: widget.width,
      height: widget.height,
      borderRadius: radius,
      backgroundColor: widget.backgroundColor,
      borderColor: widget.borderColor,
      tintColor: widget.tintColor,
      tintStrength: widget.tintStrength,
      selected: widget.selected,
      enabled: widget.enabled,
      elevated: widget.elevated,
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: widget.child,
    );

    if (_interactive) {
      card = Semantics(
        button: true,
        enabled: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _pressed ? HomiGoMotion.pressedScale : 1.0,
            duration: HomiGoMotion.fast,
            curve: HomiGoMotion.standardCurve,
            child: card,
          ),
        ),
      );
    }

    return Container(margin: widget.margin, child: card);
  }
}
