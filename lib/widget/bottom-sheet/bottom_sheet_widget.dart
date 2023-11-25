import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({
    Key? key,
    this.child,
    this.borderRadius = Dimens.radiusDefault,
  }) : super(key: key);

  final Widget? child;
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
            padding: const EdgeInsets.all(Dimens.spacingSizeSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      NavigationHelper.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                if (child != null) child!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
