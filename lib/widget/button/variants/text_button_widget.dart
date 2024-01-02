import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.child,
    this.loadingMsg,
    this.width,
    this.height = 30,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 10,
    ),
    this.fontWeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Widget? child;
  final String? loadingMsg;
  final double? width;
  final double? height;
  final double fontSize;
  final EdgeInsets padding;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      width: width,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      enabled: enabled,
      loadingMsg: loadingMsg,
      needBorder: false,
      backgroundColor: AppColors.transparent,
      textColor: isLightMode(context) ? AppColors.grayDarker : AppColors.white,
      padding: padding,
      child: child,
    );
  }
}
