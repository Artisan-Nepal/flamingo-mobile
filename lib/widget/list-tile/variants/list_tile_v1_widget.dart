import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class ListTileV1Wdiget extends StatelessWidget {
  const ListTileV1Wdiget({
    super.key,
    required this.title,
    this.value,
    this.onPressed,
  });
  final String title;
  final String? value;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(Dimens.spacing_12),
        margin: const EdgeInsets.only(bottom: Dimens.spacingSizeDefault),
        decoration: BoxDecoration(
          color: isLightMode(context)
              ? AppColors.grayLighter
              : AppColors.grayDarker,
          borderRadius: BorderRadius.circular(Dimens.radiusDefault),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    title,
                    style: textTheme(context).bodySmall!.copyWith(
                          color: isLightMode(context)
                              ? AppColors.grayDark
                              : AppColors.grayLighter,
                        ),
                  ),
                  TextWidget(
                    value ?? "Enter ${title.toLowerCase()}",
                    style: textTheme(context).titleSmall!.copyWith(
                          fontWeight: value == null ? null : FontWeight.w600,
                          fontSize:
                              value == null ? Dimens.fontSizeDefault : null,
                          color: value == null ? AppColors.grayDarker : null,
                        ),
                  ),
                ],
              ),
            ),
            const HorizontalSpaceWidget(width: Dimens.spacingSizeDefault),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
