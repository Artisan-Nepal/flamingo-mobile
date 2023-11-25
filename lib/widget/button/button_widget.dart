import 'package:flutter/material.dart';
import 'package:flamingo/shared/shared.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.label,
    this.onPressed,
    this.height = 50,
    this.textColor,
    this.width = double.infinity,
    this.isLoading = false,
    this.fontSize = 14,
    this.enabled = true,
    this.needBorder = false,
    this.child,
    this.loadingMsg,
    this.backgroundColor,
    this.borderColor = AppColors.grayLight,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 20,
    ),
    this.loaderSize = 24,
    this.borderRaidus,
  }) : super(key: key);

  final String label;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final bool isLoading;
  final double fontSize;
  final bool enabled;
  final bool needBorder;
  final Widget? child;
  final String? loadingMsg;
  final Color? backgroundColor;
  final Color borderColor;
  final EdgeInsets padding;
  final double loaderSize;
  final Color? textColor;
  final BorderRadius? borderRaidus;

  @override
  Widget build(BuildContext context) {
    final themedBackgroundColor =
        backgroundColor ?? themedPrimaryColor(context);
    final themedTextColor = (isLightMode(context)
        ? AppColors.darkModePrimary
        : AppColors.lightModePrimary);
    final textStyle =
        TypographyStyles.bodyLarge.copyWith(color: themedTextColor);
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: padding,
          backgroundColor: themedBackgroundColor,
          shape: RoundedRectangleBorder(
            side: needBorder ? BorderSide(color: borderColor) : BorderSide.none,
            borderRadius: borderRaidus ?? BorderRadius.circular(5),
          ),
        ),
        onPressed: isLoading || !enabled ? null : onPressed,
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: loaderSize,
                    width: loaderSize,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        themedTextColor,
                      ),
                    ),
                  ),
                  if (loadingMsg != null) ...[
                    const SizedBox(width: 20),
                    Text(
                      loadingMsg!,
                      style: textStyle,
                    )
                  ]
                ],
              )
            : child ??
                Text(
                  label,
                  style: textStyle,
                ),
      ),
    );
  }
}
