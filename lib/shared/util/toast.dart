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
    // AppColors.success/.error - the same feedback colors used everywhere
    // else (form validation, order status, checkout retry). Previously used
    // Theme.of(context).primaryColorLight for success, an auto-derived
    // Material default (primaryColor here is plain black/white) that never
    // matched the app's actual palette.
    backgroundColor: isSuccess ? AppColors.success : AppColors.error,
    duration: Duration(milliseconds: duration),
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimens.radiusSmall),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
