import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  const CircularProgressIndicatorWidget({
    super.key,
    this.color,
    this.size = 20,
    this.strokeWidth,
  });

  final Color? color;
  final double? size;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator.adaptive(
        strokeWidth: strokeWidth ?? 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ??
              (isLightMode(context)
                  ? AppColors.lightModePrimary
                  : AppColors.darkModePrimary),
        ),
      ),
    );
  }
}
