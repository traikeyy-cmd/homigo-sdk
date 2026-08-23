import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/liquid/homigo_liquid_surface.dart';
import '../../design_system/tokens/homigo_colors.dart';

class HomiGoTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;

  final String? label;
  final String? hintText;
  final String? errorText;

  final IconData? prefixIcon;
  final Widget? suffix;

  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  final int minLines;
  final int maxLines;
  final int? maxLength;

  final List<TextInputFormatter>? inputFormatters;

  final double? borderRadius;

  const HomiGoTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.label,
    this.hintText,
    this.errorText,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.borderRadius,
  }) : assert(
         controller == null || initialValue == null,
         'controller and initialValue cannot be used together.',
       );

  @override
  State<HomiGoTextField> createState() => _HomiGoTextFieldState();
}

class _HomiGoTextFieldState extends State<HomiGoTextField> {
  late FocusNode _focusNode;
  late bool _ownsFocusNode;

  bool get _focused => _focusNode.hasFocus;

  @override
  void initState() {
    super.initState();

    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(_handleFocus);
  }

  @override
  void didUpdateWidget(covariant HomiGoTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_handleFocus);

      if (_ownsFocusNode) {
        _focusNode.dispose();
      }

      _ownsFocusNode = widget.focusNode == null;
      _focusNode = widget.focusNode ?? FocusNode();

      _focusNode.addListener(_handleFocus);
    }
  }

  void _handleFocus() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);

    if (_ownsFocusNode) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final hasError = widget.errorText != null;

    final tintColor = hasError ? HomiGoColors.error : brand.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, bottom: 6),
            child: Text(widget.label!, style: theme.textTheme.labelMedium),
          ),
        ],
        HomiGoLiquidSurface(
          borderRadius: widget.borderRadius ?? brand.borderRadius,
          tintColor: tintColor,
          tintStrength: hasError
              ? 0.085
              : _focused
              ? 0.070
              : 0.028,
          selected: _focused || hasError,
          enabled: widget.enabled,
          padding: EdgeInsets.zero,
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            focusNode: _focusNode,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            minLines: widget.obscureText ? 1 : widget.minLines,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            cursorColor: tintColor,
            decoration: InputDecoration(
              hintText: widget.hintText,
              errorText: widget.errorText,
              filled: false,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Icon(
                      widget.prefixIcon,
                      color: tintColor.withValues(alpha: _focused ? 1.0 : 0.72),
                    ),
              suffixIcon: widget.suffix,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              errorStyle: theme.textTheme.bodySmall?.copyWith(
                color: HomiGoColors.error,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
