import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class OutlinedButtonWidget extends StatelessWidget {
  const OutlinedButtonWidget({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.child,
    this.loadingMsg,
    this.height = 50,
    this.fontSize = 14,
    this.width = double.infinity,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Widget? child;
  final String? loadingMsg;
  final double? height;
  final double? fontSize;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      enabled: enabled,
      loadingMsg: loadingMsg,
      needBorder: true,
      backgroundColor: AppColors.transparent,
      borderColor: isLightMode(context) ? AppColors.black : AppColors.white,
      textColor: isLightMode(context) ? AppColors.black : AppColors.white,
      height: height,
      fontSize: fontSize,
      width: width,
      child: child,
    );
  }
}
