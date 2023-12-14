import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class FilledButtonWidget extends StatelessWidget {
  const FilledButtonWidget({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.child,
    this.loadingMsg,
    this.width = double.infinity,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Widget? child;
  final String? loadingMsg;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      enabled: enabled,
      loadingMsg: loadingMsg,
      width: width,
      child: child,
    );
  }
}
