import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/native/homigo_native_surface.dart';
import '../../design_system/tokens/homigo_motion.dart';

/// زر الرجوع الموحد في HomiGo Native UI.
///
/// - يدعم RTL و LTR تلقائيًا.
/// - يستخدم Navigator.maybePop إذا لم يتم تمرير onPressed.
/// - منطقة لمس 44x44.
/// - بدون Blur أو Glass.
/// - يحتوي على استجابة ضغط خفيفة.
class HomiGoBackButton extends StatefulWidget {
  final VoidCallback? onPressed;

  final double size;
  final double iconSize;
  final double borderRadius;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final bool elevated;
  final bool enabled;

  final String? semanticLabel;

  const HomiGoBackButton({
    super.key,
    this.onPressed,
    this.size = 44,
    this.iconSize = 22,
    this.borderRadius = 14,
    this.backgroundColor,
    this.foregroundColor,
    this.elevated = true,
    this.enabled = true,
    this.semanticLabel,
  });

  @override
  State<HomiGoBackButton> createState() => _HomiGoBackButtonState();
}

class _HomiGoBackButtonState extends State<HomiGoBackButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final icon = isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded;

    final foreground =
        widget.foregroundColor ??
        (theme.brightness == Brightness.dark
            ? Colors.white
            : brand.primaryColor);

    final label =
        widget.semanticLabel ??
        MaterialLocalizations.of(context).backButtonTooltip;

    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: label,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: HomiGoMotion.press,
        curve: HomiGoMotion.fastCurve,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: widget.enabled
              ? (_) {
                  setState(() {
                    _pressed = true;
                  });
                }
              : null,
          onTapUp: widget.enabled
              ? (_) {
                  setState(() {
                    _pressed = false;
                  });
                }
              : null,
          onTapCancel: widget.enabled
              ? () {
                  setState(() {
                    _pressed = false;
                  });
                }
              : null,
          onTap: widget.enabled
              ? () {
                  final callback = widget.onPressed;

                  if (callback != null) {
                    callback();
                    return;
                  }

                  Navigator.of(context).maybePop();
                }
              : null,
          child: HomiGoNativeSurface(
            width: widget.size,
            height: widget.size,
            borderRadius: widget.borderRadius,
            backgroundColor: widget.backgroundColor,
            enabled: widget.enabled,
            elevated: widget.elevated,
            padding: EdgeInsets.zero,
            child: Center(
              child: Icon(icon, size: widget.iconSize, color: foreground),
            ),
          ),
        ),
      ),
    );
  }
}
