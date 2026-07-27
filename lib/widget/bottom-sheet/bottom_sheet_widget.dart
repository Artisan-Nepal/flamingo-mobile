import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flutter/material.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({
    Key? key,
    this.child,
    this.topContent,
    this.borderRadius = Dimens.radiusDefault,
  }) : super(key: key);

  final Widget? child;
  // Shares the header row with the close button instead of leaving it
  // sitting alone against a bare stretch of empty space (e.g. a small nudge
  // message in the add-to-cart sheet).
  final Widget? topContent;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        child: Material(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimens.spacingSizeLarge,
              Dimens.spacingSizeDefault,
              Dimens.spacingSizeLarge,
              Dimens.spacingSizeLarge,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Compact so the close control doesn't open a tall empty band
                // above the sheet's content - and topContent, when given,
                // fills that band instead of leaving it bare.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: topContent ?? const SizedBox.shrink()),
                    IconButton(
                      onPressed: () {
                        NavigationHelper.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(),
                      iconSize: Dimens.iconSizeDefault,
                    ),
                  ],
                ),
                const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                if (child != null) child!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
