import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    required this.title,
    this.leading,
    this.onTap,
  });

  final String title;
  final void Function()? onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding:
            const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
        margin: const EdgeInsets.only(bottom: Dimens.spacingSizeDefault),
        decoration: BoxDecoration(
          color: isLightMode(context)
              ? AppColors.grayLighter
              : AppColors.grayDarker,
          borderRadius: BorderRadius.circular(Dimens.radiusSmall),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            ],
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).iconTheme.color,
            )
          ],
        ),
      ),
    );
  }
}
