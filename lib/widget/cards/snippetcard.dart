import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

class SnippetCategorySelectionCard extends StatelessWidget {
  const SnippetCategorySelectionCard({
    super.key,
    this.isSelected = true,
    required this.name,
    this.icon,
    this.onPressed,
  });

  final bool isSelected;
  final String name;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grayLight),
          borderRadius: BorderRadius.circular(Dimens.radiusSmall),
          color: _getBackgroundColor(context),
        ),
        padding: const EdgeInsets.all(Dimens.spacingSizeSmall),
        constraints: BoxConstraints(
          maxWidth: SizeConfig.screenWidth * 0.5 - Dimens.spacingSizeDefault,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: _getContentColor(context),
                size: Dimens.iconSizeSmall,
              ),
              const BottomSpaceWidget(height: Dimens.spacingSizeExtraSmall)
            ],
            TextWidget(
              name,
              style: textTheme(context).bodySmall!.copyWith(
                    color: _getContentColor(context),
                    fontWeight: FontWeight.bold,
                  ),
            )
          ],
        ),
      ),
    );
  }

  Color? _getBackgroundColor(BuildContext context) {
    if (isSelected) return AppColors.primaryMain;
    return null;
  }

  Color? _getContentColor(BuildContext context) {
    if (isSelected) return AppColors.white;
    return null;
  }
}
