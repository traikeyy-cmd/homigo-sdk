import 'package:flutter/material.dart';

import 'homigo_card.dart';

/// Compatibility wrapper for the old HomiGo card API.
///
/// الاسم [HomiGoGlassCard] محفوظ حتى لا تنكسر التطبيقات الحالية.
///
/// التنفيذ الفعلي أصبح [HomiGoCard] ضمن HomiGo Native UI.
///
/// [blur] و [opacity] محفوظان فقط للتوافق،
/// ولا يتم استخدام Glass أو Blur.
class HomiGoGlassCard extends StatefulWidget {
  final Widget child;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final double? width;
  final double? height;

  final double? borderRadius;

  /// محفوظ للتوافق فقط.
  final double? blur;

  /// محفوظ للتوافق فقط.
  final double? opacity;

  final Color? backgroundColor;
  final Color? borderColor;

  final VoidCallback? onTap;

  final bool enabled;
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
  @override
  Widget build(BuildContext context) {
    return HomiGoCard(
      padding: widget.padding,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      borderRadius: widget.borderRadius,
      backgroundColor: widget.backgroundColor,
      borderColor: widget.borderColor,
      onTap: widget.onTap,
      enabled: widget.enabled,
      selected: widget.selected,
      child: widget.child,
    );
  }
}
