import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/native/homigo_native_surface.dart';
import '../../design_system/tokens/homigo_colors.dart';
import '../cards/homigo_glass_card.dart';

class HomiGoListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;

  const HomiGoListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: HomiGoNativeSurface(
          borderRadius: 16,
          tintColor: brand.primaryColor,
          selected: selected,
          tintStrength: selected ? 0.08 : 0.015,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 12)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: selected ? FontWeight.w700 : null,
                        color: selected ? brand.primaryColor : null,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(subtitle!, style: theme.textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 10), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

class HomiGoExpansionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> children;
  final bool initiallyExpanded;

  const HomiGoExpansionTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HomiGoGlassCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          leading: leading,
          title: Text(title),
          subtitle: subtitle == null ? null : Text(subtitle!),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: children,
        ),
      ),
    );
  }
}

class HomiGoChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;
  final Color? tintColor;

  const HomiGoChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
    this.tintColor,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final tint = tintColor ?? brand.primaryColor;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: HomiGoNativeSurface(
          borderRadius: 999,
          tintColor: tint,
          selected: selected,
          tintStrength: selected ? 0.09 : 0.018,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 17,
                  color: selected ? tint : theme.iconTheme.color,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: selected ? tint : null,
                  fontWeight: selected ? FontWeight.w700 : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomiGoBadge extends StatelessWidget {
  final String text;
  final Color? tintColor;
  final Widget? child;

  const HomiGoBadge({
    super.key,
    required this.text,
    this.tintColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final tint = tintColor ?? brand.primaryColor;

    final badge = HomiGoNativeSurface(
      borderRadius: 999,
      tintColor: tint,
      tintStrength: 0.09,
      selected: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: tint,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (child == null) {
      return badge;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        PositionedDirectional(top: -8, end: -8, child: badge),
      ],
    );
  }
}

class HomiGoAvatar extends StatelessWidget {
  final ImageProvider? image;
  final String? initials;
  final IconData fallbackIcon;
  final double radius;
  final Color? tintColor;

  const HomiGoAvatar({
    super.key,
    this.image,
    this.initials,
    this.fallbackIcon = Icons.person_rounded,
    this.radius = 24,
    this.tintColor,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    final tint = tintColor ?? brand.primaryColor;
    final size = radius * 2;

    return HomiGoNativeSurface(
      width: size,
      height: size,
      borderRadius: 999,
      tintColor: tint,
      selected: true,
      tintStrength: 0.075,
      padding: EdgeInsets.zero,
      child: ClipOval(
        child: image != null
            ? Image(image: image!, width: size, height: size, fit: BoxFit.cover)
            : Center(
                child: initials != null
                    ? Text(
                        initials!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: tint,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : Icon(fallbackIcon, color: tint, size: radius),
              ),
      ),
    );
  }
}

enum HomiGoStatus { info, success, warning, error, neutral }

class HomiGoStatusBadge extends StatelessWidget {
  final String label;
  final HomiGoStatus status;

  const HomiGoStatusBadge({
    super.key,
    required this.label,
    this.status = HomiGoStatus.info,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = switch (status) {
      HomiGoStatus.info => HomiGoColors.info,
      HomiGoStatus.success => HomiGoColors.success,
      HomiGoStatus.warning => HomiGoColors.warning,
      HomiGoStatus.error => HomiGoColors.error,
      HomiGoStatus.neutral => theme.textTheme.bodySmall?.color ?? Colors.grey,
    };

    return HomiGoNativeSurface(
      borderRadius: 999,
      tintColor: color,
      tintStrength: 0.075,
      selected: true,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class HomiGoDivider extends StatelessWidget {
  final double indent;
  final double endIndent;

  const HomiGoDivider({super.key, this.indent = 0, this.endIndent = 0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsetsDirectional.only(start: indent, end: endIndent),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            theme.dividerColor.withValues(alpha: 0.55),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class HomiGoSection extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const HomiGoSection({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HomiGoGlassCard(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || trailing != null)
            Row(
              children: [
                if (title != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title!, style: theme.textTheme.titleMedium),
                        if (subtitle != null) ...[
                          const SizedBox(height: 3),
                          Text(subtitle!, style: theme.textTheme.bodySmall),
                        ],
                      ],
                    ),
                  ),
                ?trailing,
              ],
            ),
          if (title != null || trailing != null) const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class HomiGoSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const HomiGoSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 14,
  });

  @override
  State<HomiGoSkeleton> createState() => _HomiGoSkeletonState();
}

class _HomiGoSkeletonState extends State<HomiGoSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final value = (_controller.value * 2) - 1;

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(value - 1, 0),
              end: Alignment(value + 1, 0),
              colors: [
                Colors.white.withValues(alpha: isDark ? 0.035 : 0.08),
                Colors.white.withValues(alpha: isDark ? 0.11 : 0.26),
                Colors.white.withValues(alpha: isDark ? 0.035 : 0.08),
              ],
            ),
          ),
        );
      },
    );
  }
}
