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
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spacingSizeDefault,
                vertical: Dimens.spacingSizeExtraSmall,
              ),
              margin: const EdgeInsets.only(
                left: Dimens.spacingSizeDefault,
                bottom: Dimens.spacingSizeDefault,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryMain),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(title)),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: onCancel,
          child: const Padding(
            padding: EdgeInsets.only(
              bottom: Dimens.spacingSizeDefault,
            ),
            child: Icon(
              Icons.cancel,
              color: AppColors.primaryMain,
            ),
          ),
        ),
      ],
    );
  }
}
