import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class ListTileV2Wdiget extends StatelessWidget {
  const ListTileV2Wdiget({
    super.key,
    required this.title,
    this.onPressed,
  });
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimens.spacing_12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.grayLighter,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextWidget(
                title,
                style: textTheme(context).bodyMedium!.copyWith(
                      color: isLightMode(context)
                          ? AppColors.grayDark
                          : AppColors.grayLighter,
                    ),
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
