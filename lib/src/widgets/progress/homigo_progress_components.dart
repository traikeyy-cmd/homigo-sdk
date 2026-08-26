import 'package:flutter/material.dart';

import '../../core/config/homigo_sdk_core.dart';
import '../../design_system/native/homigo_native_surface.dart';

class HomiGoProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color? tintColor;

  const HomiGoProgressBar({
    super.key,
    required this.value,
    this.height = 12,
    this.tintColor,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final tint = tintColor ?? brand.primaryColor;
    final progress = value.clamp(0.0, 1.0);

    return HomiGoNativeSurface(
      height: height,
      borderRadius: 999,
      tintColor: tint,
      tintStrength: 0.012,
      padding: const EdgeInsets.all(2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: AlignmentDirectional.centerStart,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOut,
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(
                  colors: [
                    tint.withValues(alpha: 0.48),
                    tint.withValues(alpha: 0.82),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomiGoCircularProgress extends StatelessWidget {
  final double? value;
  final double size;
  final double strokeWidth;
  final Color? tintColor;
  final Widget? child;

  const HomiGoCircularProgress({
    super.key,
    this.value,
    this.size = 54,
    this.strokeWidth = 4,
    this.tintColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final tint = tintColor ?? brand.primaryColor;

    return HomiGoNativeSurface(
      width: size,
      height: size,
      borderRadius: 999,
      tintColor: tint,
      tintStrength: 0.04,
      padding: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: strokeWidth,
            color: tint,
            backgroundColor: tint.withValues(alpha: 0.10),
          ),
          ?child,
        ],
      ),
    );
  }
}

@immutable
class HomiGoStep {
  final String title;
  final String? subtitle;
  final IconData? icon;

  const HomiGoStep({required this.title, this.subtitle, this.icon});
}

class HomiGoStepper extends StatelessWidget {
  final List<HomiGoStep> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTapped;

  const HomiGoStepper({
    super.key,
    required this.steps,
    required this.currentStep,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    final brand = HomiGoSDK.config.brand;
    final theme = Theme.of(context);

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final completed = index < currentStep;
        final active = index == currentStep;

        final tint = completed || active
            ? brand.primaryColor
            : theme.disabledColor;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 44,
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                      child: InkWell(
                        onTap: onStepTapped == null
                            ? null
                            : () => onStepTapped!(index),
                        borderRadius: BorderRadius.circular(999),
                        child: HomiGoNativeSurface(
                          width: 36,
                          height: 36,
                          borderRadius: 999,
                          tintColor: tint,
                          selected: active || completed,
                          tintStrength: active || completed ? 0.085 : 0.012,
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: completed
                                ? Icon(
                                    Icons.check_rounded,
                                    size: 18,
                                    color: tint,
                                  )
                                : Icon(
                                    step.icon ?? Icons.circle_outlined,
                                    size: 18,
                                    color: tint,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    if (index != steps.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: brand.primaryColor.withValues(
                            alpha: completed ? 0.40 : 0.08,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 7, bottom: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: active ? brand.primaryColor : null,
                          fontWeight: active ? FontWeight.w700 : null,
                        ),
                      ),
                      if (step.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(step.subtitle!, style: theme.textTheme.bodySmall),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
