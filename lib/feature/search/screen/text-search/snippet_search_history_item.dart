import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class SnippetSearchHistoryItem extends StatelessWidget {
  const SnippetSearchHistoryItem({
    Key? key,
    required this.title,
    this.onTap,
    this.onCancel,
  }) : super(key: key);

  final String title;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
              padding: const EdgeInsets.only(
                left: Dimens.spacingSizeSmall,
                right: Dimens.spacingSizeExtraSmall,
                top: Dimens.spacingSizeExtraSmall,
                bottom: Dimens.spacingSizeExtraSmall,
              ),
              margin: const EdgeInsets.only(
                left: Dimens.spacingSizeDefault,
                bottom: Dimens.spacingSizeDefault,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryMain),
                borderRadius: BorderRadius.circular(Dimens.radiusSmall),
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: textTheme(context).bodySmall,
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: onCancel,
                    child: Icon(
                      Icons.close,
                      size: Dimens.iconSize_15,
                      color: AppColors.primaryMain,
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
