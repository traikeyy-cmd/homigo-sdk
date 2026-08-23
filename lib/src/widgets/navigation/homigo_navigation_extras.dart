import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/liquid/homigo_liquid_surface.dart';
import '../cards/homigo_glass_card.dart';

class HomiGoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget> actions;
  final bool centerTitle;

  const HomiGoAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions = const [],
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: HomiGoLiquidSurface(
        borderRadius: 0,
        tintColor: brand.primaryColor,
        tintStrength: 0.012,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              SizedBox(width: 48, child: leading),
              Expanded(
                child: Align(
                  alignment: centerTitle
                      ? Alignment.center
                      : AlignmentDirectional.centerStart,
                  child:
                      titleWidget ??
                      Text(title ?? '', style: theme.textTheme.titleLarge),
                ),
              ),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}

class HomiGoDrawer extends StatelessWidget {
  final Widget child;
  final double width;

  const HomiGoDrawer({super.key, required this.child, this.width = 310});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: width,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: HomiGoGlassCard(
            borderRadius: 28,
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

class HomiGoPageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final double dotSize;
  final Color? tintColor;

  const HomiGoPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.dotSize = 8,
    this.tintColor,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final tint = tintColor ?? brand.primaryColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final selected = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: selected ? dotSize * 2.6 : dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: tint.withValues(alpha: selected ? 0.82 : 0.18),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: tint.withValues(alpha: 0.18),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
