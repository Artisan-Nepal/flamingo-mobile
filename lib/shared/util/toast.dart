import 'package:flutter/material.dart';
import 'package:flamingo/shared/util/util.dart';

void showToast(BuildContext context,
    {String? message, bool isSuccess = true, int duration = 1000}) {
  final snackBar = SnackBar(
    content: Center(
      child: Text(
        message ?? (isSuccess ? 'Success' : 'An error occured'),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.white,
            ),
      ),
    ),
    // Success uses the app's pink accent (secondaryMain) so positive feedback
    // reads as on-brand rather than generic "system green". Errors keep the
    // conventional red, the same feedback color used everywhere else (form
    // validation, order status, checkout retry).
    backgroundColor: isSuccess ? AppColors.secondaryMain : AppColors.error,
    duration: Duration(milliseconds: duration),
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimens.radiusSmall),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
