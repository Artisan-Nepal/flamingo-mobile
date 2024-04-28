import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

void showToast(BuildContext context,
    {String? message, bool isSuccess = true, int duration = 1000}) {
  final snackBar = SnackBar(
    content: Center(
      child: Text(
        message ?? (isSuccess ? 'Success' : ErrorMessages.defaultError),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: isSuccess ? AppColors.grayDarker : AppColors.white,
            ),
      ),
    ),
    backgroundColor:
        isSuccess ? Theme.of(context).primaryColorLight : AppColors.error,
    duration: Duration(milliseconds: duration),
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimens.radiusSmall),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
