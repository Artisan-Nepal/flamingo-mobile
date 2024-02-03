import 'package:flamingo/shared/enum/alert_dialog_type.dart';
import 'package:flamingo/shared/util/util.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({
    Key? key,
    required this.title,
    this.description = '',
    this.firstButtonOnPressed,
    this.firstButtonLabel = 'Ok',
    this.secondButtonLabel = 'Cancel',
    this.needSecondButton = true,
    this.firstButtonIsLoading = false,
    this.secondButtonOnPressed,
    this.dialogType = AlertDialogType.alert,
  }) : super(key: key);

  final String title;
  final String description;
  final dynamic firstButtonOnPressed;
  final VoidCallback? secondButtonOnPressed;
  final String firstButtonLabel;
  final String secondButtonLabel;
  final bool needSecondButton;
  final bool firstButtonIsLoading;
  final AlertDialogType dialogType;

  @override
  Widget build(BuildContext context) {
    defaultAction() {
      Navigator.pop(context);
    }

    return AlertDialog(
      content: Text(
        description,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      contentPadding: EdgeInsets.only(
        left: Dimens.spacingSizeLarge,
        right: Dimens.spacingSizeLarge,
        bottom: description.isEmpty ? 0 : Dimens.spacingSizeLarge,
        top: description.isEmpty ? 0 : Dimens.spacingSizeDefault,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.radiusSmall),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actionsPadding: const EdgeInsets.only(
        left: Dimens.spacingSizeLarge,
        right: Dimens.spacingSizeLarge,
        bottom: Dimens.spacingSizeLarge,
      ),
      actionsAlignment: needSecondButton
          ? MainAxisAlignment.spaceAround
          : MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: SizeConfig.screenWidth,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButtonWidget(
                  height: 40,
                  label: secondButtonLabel,
                  onPressed: secondButtonOnPressed ?? defaultAction,
                ),
              ),
              const HorizontalSpaceWidget(width: Dimens.spacing_8),
              Expanded(
                flex: 1,
                child: ButtonWidget(
                  height: 40,
                  isLoading: firstButtonIsLoading,
                  label: firstButtonLabel,
                  onPressed: firstButtonOnPressed ?? defaultAction,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
