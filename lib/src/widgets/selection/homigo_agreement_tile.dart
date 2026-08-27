import 'package:flutter/material.dart';

import '../../design_system/native/homigo_native_surface.dart';
import '../../design_system/theme/homigo_dynamic_colors.dart';
import '../../design_system/tokens/homigo_colors.dart';
import '../../design_system/tokens/homigo_motion.dart';
import '../../design_system/tokens/homigo_radius.dart';

/// مربع مخصص للموافقات مثل الشروط والأحكام وسياسة الخصوصية.
///
/// يختلف بصريًا عن TextField:
/// - ارتفاعه يتحدد حسب النص.
/// - النص يلتف تلقائيًا على أكثر من سطر.
/// - يحتوي Checkbox مدمج.
/// - كامل المربع قابل للضغط.
/// - بدون Glass أو Blur.
class HomiGoAgreementTile extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  final String text;
  final String? helperText;

  final Widget? trailing;

  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const HomiGoAgreementTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
    this.helperText,
    this.trailing,
    this.borderRadius = HomiGoRadius.lg,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  State<HomiGoAgreementTile> createState() => _HomiGoAgreementTileState();
}

class _HomiGoAgreementTileState extends State<HomiGoAgreementTile> {
  bool _pressed = false;

  bool get _enabled => widget.onChanged != null;

  void _toggle() {
    widget.onChanged?.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = HomiGoDynamicColors.primary(context);

    final isDark = theme.brightness == Brightness.dark;

    final idleBorder = isDark
        ? HomiGoColors.darkBorder
        : HomiGoColors.lightBorder;

    final borderColor = widget.value
        ? primary.withValues(alpha: 0.42)
        : idleBorder;

    return Semantics(
      button: true,
      checked: widget.value,
      enabled: _enabled,
      child: AnimatedScale(
        scale: _pressed ? 0.985 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: HomiGoMotion.fastCurve,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _enabled
              ? (_) {
                  setState(() {
                    _pressed = true;
                  });
                }
              : null,
          onTapUp: _enabled
              ? (_) {
                  setState(() {
                    _pressed = false;
                  });
                }
              : null,
          onTapCancel: _enabled
              ? () {
                  setState(() {
                    _pressed = false;
                  });
                }
              : null,
          onTap: _enabled ? _toggle : null,
          child: HomiGoNativeSurface(
            borderRadius: widget.borderRadius,
            borderColor: borderColor,
            selected: widget.value,
            tintColor: primary,
            enabled: _enabled,
            elevated: false,
            padding: widget.padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 170),
                  curve: HomiGoMotion.standardCurve,
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: widget.value ? primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: widget.value ? primary : idleBorder,
                      width: 1.4,
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: HomiGoMotion.fast,
                    child: widget.value
                        ? Icon(
                            Icons.check_rounded,
                            key: const ValueKey('agreement_checked'),
                            size: 17,
                            color: theme.colorScheme.onPrimary,
                          )
                        : const SizedBox(key: ValueKey('agreement_unchecked')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.text,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                        ),
                      ),
                      if (widget.helperText != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          widget.helperText!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withValues(
                              alpha: 0.68,
                            ),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.trailing != null) ...[
                  const SizedBox(width: 8),
                  widget.trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
