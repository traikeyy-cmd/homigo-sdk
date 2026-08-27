import 'package:flutter/material.dart';

import '../../design_system/native/homigo_native_surface.dart';
import '../../design_system/theme/homigo_dynamic_colors.dart';
import '../../design_system/tokens/homigo_radius.dart';
import '../cards/homigo_glass_card.dart';

class HomiGoIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? tintColor;
  final double size;

  const HomiGoIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.tintColor,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    final tint = tintColor ?? HomiGoDynamicColors.primary(context);

    Widget result = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: HomiGoNativeSurface(
          width: size,
          height: size,
          borderRadius: 15,
          tintColor: tint,
          tintStrength: 0.04,
          padding: EdgeInsets.zero,
          child: Center(
            child: Icon(
              icon,
              size: size * 0.48,
              color: onPressed == null ? Theme.of(context).disabledColor : tint,
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      result = Tooltip(message: tooltip!, child: result);
    }

    return result;
  }
}

class HomiGoFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? tintColor;
  final double size;

  const HomiGoFloatingActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.tintColor,
    this.size = 58,
  });

  @override
  Widget build(BuildContext context) {
    final tint = tintColor ?? HomiGoDynamicColors.primary(context);

    Widget button = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(HomiGoRadius.pill),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(HomiGoRadius.pill),
        child: HomiGoNativeSurface(
          width: size,
          height: size,
          borderRadius: HomiGoRadius.pill,
          tintColor: tint,
          tintStrength: 0.09,
          selected: true,
          padding: EdgeInsets.zero,
          child: Center(
            child: Icon(icon, color: tint, size: size * 0.43),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

class HomiGoTooltip extends StatelessWidget {
  final String message;
  final Widget child;

  const HomiGoTooltip({super.key, required this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    final primary = HomiGoDynamicColors.primary(context);
    final secondary = HomiGoDynamicColors.secondary(context);

    return Tooltip(
      message: message,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            primary.withValues(alpha: 0.72),
            secondary.withValues(alpha: 0.58),
          ],
        ),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      child: child,
    );
  }
}

@immutable
class HomiGoMenuAction {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const HomiGoMenuAction({required this.label, this.icon, this.onTap});
}

class HomiGoMenu extends StatelessWidget {
  final List<HomiGoMenuAction> items;

  const HomiGoMenu({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final primary = HomiGoDynamicColors.primary(context);
    final theme = Theme.of(context);

    return HomiGoGlassCard(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(HomiGoRadius.md),
              child: InkWell(
                onTap: items[i].onTap,
                borderRadius: BorderRadius.circular(HomiGoRadius.md),
                child: HomiGoNativeSurface(
                  borderRadius: HomiGoRadius.md,
                  tintColor: primary,
                  tintStrength: 0.015,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      if (items[i].icon != null) ...[
                        Icon(items[i].icon, size: 20, color: primary),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          items[i].label,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (i != items.length - 1) const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

@immutable
class HomiGoPopupMenuItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const HomiGoPopupMenuItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

class HomiGoPopupMenu<T> extends StatefulWidget {
  final Widget child;
  final List<HomiGoPopupMenuItem<T>> items;
  final ValueChanged<T>? onSelected;

  const HomiGoPopupMenu({
    super.key,
    required this.child,
    required this.items,
    this.onSelected,
  });

  @override
  State<HomiGoPopupMenu<T>> createState() => _HomiGoPopupMenuState<T>();
}

class _HomiGoPopupMenuState<T> extends State<HomiGoPopupMenu<T>> {
  final GlobalKey _key = GlobalKey();

  Future<void> _show() async {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return;
    }

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);

    final position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + renderBox.size.height,
      overlay.size.width - offset.dx - renderBox.size.width,
      overlay.size.height - offset.dy - renderBox.size.height,
    );

    final primary = HomiGoDynamicColors.primary(context);
    final theme = Theme.of(context);

    final selected = await showMenu<T>(
      context: context,
      position: position,
      elevation: 0,
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      items: widget.items.map((item) {
        return PopupMenuItem<T>(
          value: item.value,
          padding: EdgeInsets.zero,
          child: HomiGoNativeSurface(
            borderRadius: HomiGoRadius.md,
            tintColor: primary,
            tintStrength: 0.028,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(item.icon, size: 19, color: primary),
                  const SizedBox(width: 10),
                ],
                Text(item.label, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        );
      }).toList(),
    );

    if (selected != null) {
      widget.onSelected?.call(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: _show,
      behavior: HitTestBehavior.opaque,
      child: widget.child,
    );
  }
}
