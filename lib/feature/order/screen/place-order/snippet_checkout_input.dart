import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class SnippetCheckoutInput extends StatelessWidget {
  const SnippetCheckoutInput({
    Key? key,
    required this.label,
    this.onPressed,
    required this.isSet,
    required this.placeholder,
    required this.value,
    this.enabled = true,
  }) : super(key: key);

  final String label;
  final VoidCallback? onPressed;
  final bool isSet;
  final String placeholder;
  final String value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        color: AppColors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
              child: isSet
                  ? const Icon(
                      Icons.check_circle_outline,
                      size: Dimens.iconSize_22,
                      color: AppColors.success,
                    )
                  : const SizedBox(),
            ),
            const SizedBox(
              width: Dimens.spacingSizeDefault,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme(context)
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  isSet ? Text(value) : Text(placeholder)
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.chevron_right,
            ),
          ],
        ),
      ),
    );
  }
}
