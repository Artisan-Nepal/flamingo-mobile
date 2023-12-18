import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({
    Key? key,
    this.message,
    this.firstButtonOnPressed,
    this.firstButtonLabel = 'Ok',
    this.secondButtonLabel = 'Cancel',
    this.needSecondButton = false,
    this.secondButtonOnPressed,
    this.dialogType = AlertDialogType.alert,
    required this.title,
  }) : super(key: key);

  final String title;
  final String? message;
  final VoidCallback? firstButtonOnPressed;
  final VoidCallback? secondButtonOnPressed;
  final String firstButtonLabel;
  final String secondButtonLabel;
  final bool needSecondButton;
  final AlertDialogType dialogType;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      title: Center(
          child: Text(
        title,
        textAlign: TextAlign.center,
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message != null) ...[
            Text(
              message!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimens.spacingSizeLarge),
          ],
          ButtonWidget(
            height: 40,
            label: firstButtonLabel,
            onPressed: firstButtonOnPressed ??
                () {
                  Navigator.pop(context);
                },
          ),
          if (needSecondButton) ...[
            const SizedBox(height: Dimens.spacingSizeDefault),
            OutlinedButtonWidget(
              label: secondButtonLabel,
              height: 40,
              onPressed: secondButtonOnPressed ??
                  () {
                    Navigator.pop(context);
                  },
            ),
          ],
        ],
      ),
      titlePadding: const EdgeInsets.only(
        top: Dimens.spacingSizeLarge,
        left: Dimens.spacingSizeLarge,
        right: Dimens.spacingSizeLarge,
      ),
      insetPadding:
          EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.15),
      // actionsPadding: const EdgeInsets.only(
      //     left: Dimens.paddingSizeDefault,
      //     right: Dimens.paddingSizeDefault,
      //     bottom: Dimens.paddingSizeSmall),
      // actionsAlignment: needSecondButton
      //     ? MainAxisAlignment.spaceAround
      //     : MainAxisAlignment.center,
      // actions:
    );
  }
}
