import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class DefaultErrorWidget extends StatelessWidget {
  const DefaultErrorWidget({
    Key? key,
    this.errorMessage = '',
    this.onActionButtonPressed,
    this.needImage = true,
    this.fontSize = Dimens.fontSizeOverLarge,
    this.actionButtonLabel = 'Try again',
    this.manuallyCenter = false,
  }) : super(key: key);

  final String errorMessage;
  final VoidCallback? onActionButtonPressed;
  final String actionButtonLabel;
  final bool needImage;
  final double fontSize;
  final bool manuallyCenter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: Dimens.spacing_64,
          top: manuallyCenter ? SizeConfig.screenHeight * 0.2 : 0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (needImage) ...[
                  Image.asset(
                    ImageConstants.appLogo,
                    height: 200,
                    width: 280,
                    color: AppColors.grayMain,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.spacingSizeLarge),
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                        color: AppColors.grayMain,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.1),
            if (onActionButtonPressed != null) ...[
              OutlinedButtonWidget(
                label: actionButtonLabel,
                onPressed: onActionButtonPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
