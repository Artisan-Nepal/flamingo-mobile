import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class DefaultErrorWidget extends StatelessWidget {
  const DefaultErrorWidget({
    Key? key,
    this.errorMessage = '',
    this.onTryAgain,
    this.needImage = true,
    this.fontSize = Dimens.fontSizeOverLarge,
  }) : super(key: key);

  final String errorMessage;
  final VoidCallback? onTryAgain;
  final bool needImage;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          if (onTryAgain != null) ...[
            OutlinedButtonWidget(
              label: 'Try again',
              onPressed: onTryAgain,
            ),
          ],
        ],
      ),
    );
  }
}
