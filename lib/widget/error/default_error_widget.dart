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
    this.manualTop,
    this.useListView = false,
  }) : super(key: key);

  final String errorMessage;
  final VoidCallback? onActionButtonPressed;
  final String actionButtonLabel;
  final bool needImage;
  final double fontSize;
  final bool manuallyCenter;
  final double? manualTop;
  final bool useListView;

  @override
  Widget build(BuildContext context) {
    if (useListView) {
      return ListView(
        children: [
          _buildChildren(),
        ],
      );
    }

    return _buildChildren();
  }

  Widget _buildChildren() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: Dimens.spacing_64,
          top: manuallyCenter
              ? SizeConfig.screenHeight * (manualTop ?? 0.2)
              : 0),
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
                    ImageConstants.errorPlaceholder,
                    height: 100,
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
            SizedBox(height: SizeConfig.screenHeight * 0.05),
            if (onActionButtonPressed != null) ...[
              OutlinedButtonWidget(
                width: 200,
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
