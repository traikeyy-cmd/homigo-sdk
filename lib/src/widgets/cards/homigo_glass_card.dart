import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/native/homigo_native_surface.dart';

/// بطاقة HomiGo الموحدة.
///
/// الاسم [HomiGoGlassCard] محفوظ للتوافق مع التطبيقات الحالية،
/// لكن التنفيذ الداخلي أصبح Native UI بدون Glass أو Blur.
class HomiGoGlassCard extends StatefulWidget {
  final Widget child;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final double? width;
  final double? height;

  final double? borderRadius;

  /// محفوظ للتوافق مع الإصدارات السابقة.
  ///
  /// لم يعد مستخدمًا في Native UI.
  final double? blur;

  /// محفوظ للتوافق مع الإصدارات السابقة.
  ///
  /// لم يعد يتحكم في Glass opacity.
  final double? opacity;

  final Color? backgroundColor;
  final Color? borderColor;

  final VoidCallback? onTap;

  final bool enabled;

  /// إذا كانت البطاقة في حالة اختيار أو تركيز.
  final bool selected;

  const HomiGoGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.blur,
    this.opacity,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.enabled = true,
    this.selected = false,
  });

  @override
  State<HomiGoGlassCard> createState() => _HomiGoGlassCardState();
}

class _HomiGoGlassCardState extends State<HomiGoGlassCard> {
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

    final effectiveRadius = widget.borderRadius ?? brand.borderRadius;

    Widget card = HomiGoNativeSurface(
      width: widget.width,
      height: widget.height,
      borderRadius: effectiveRadius,
      backgroundColor: widget.backgroundColor,
      borderColor: widget.borderColor,
      selected: widget.selected,
      enabled: widget.enabled,
      elevated: true,
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
            scale: _pressed ? 0.98 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            child: card,
          ),
        ),
      );
    }

    return Container(margin: widget.margin, child: card);
  }
}
