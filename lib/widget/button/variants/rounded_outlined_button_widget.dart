import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class RoundedOutlinedButtonWidget extends StatelessWidget {
  const RoundedOutlinedButtonWidget({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.child,
    this.loadingMsg,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Widget? child;
  final String? loadingMsg;

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      enabled: enabled,
      loadingMsg: loadingMsg,
      borderRaidus: BorderRadius.circular(50),
      needBorder: true,
      backgroundColor: AppColors.transparent,
      textColor: AppColors.grayDarker,
      child: child,
    );
  }
}
