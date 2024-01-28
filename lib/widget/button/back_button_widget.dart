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
    return Container(
      color: AppColors.transparent,
      child: GestureDetector(
        onTap: onPressed ??
            () {
              NavigationHelper.pop(context);
            },
        child: Icon(
          CupertinoIcons.back,
          size: size ?? Dimens.iconSizeLarge,
        ),
      ),
    );
  }
}
