import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class SmallButtonWidget extends StatelessWidget {
  const SmallButtonWidget({
    Key? key,
    required this.onPressed,
    this.enabled = true,
    required this.icon,
    this.padding = EdgeInsets.zero,
    this.height,
    this.width,
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool enabled;
  final IconData icon;
  final EdgeInsets padding;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: enabled
            ? themedPrimaryColor(context)
            : isLightMode(context)
                ? AppColors.grayLight
                : AppColors.grayMain,
      ),
      child: IconButton(
        iconSize: 20,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.zero,
        onPressed: enabled ? onPressed : null,
        icon: Icon(
          icon,
          color: enabled
              ? isLightMode(context)
                  ? AppColors.white
                  : AppColors.black
              : isLightMode(context)
                  ? AppColors.grayLighter
                  : AppColors.grayLight,
        ),
      ),
    );
  }
}
