import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    super.key,
    this.size,
    this.onPressed,
  });

  final double? size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ??
          () {
            NavigationHelper.pop(context);
          },
      child: Container(
        color: AppColors.transparent,
        padding: EdgeInsets.symmetric(horizontal: Dimens.spacingSizeExtraSmall),
        child: Icon(
          CupertinoIcons.back,
          size: size ?? Dimens.iconSizeLarge,
        ),
      ),
    );
  }
}
