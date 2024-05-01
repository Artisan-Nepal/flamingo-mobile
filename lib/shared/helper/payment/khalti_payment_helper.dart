import 'dart:async';

import 'package:flamingo/shared/constant/common_constants.dart';
import 'package:flamingo/shared/constant/message/message.dart';
import 'package:flamingo/shared/helper/payment/payment_helper.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';

class KhaltiPaymentHelper implements PaymentHelper {
  FutureOr<void> pay(
    BuildContext context, {
    required int amount,
    required String checkoutId,
    required String checkoutName,
    required FutureOr<void> Function(PaymentSuccessResponse successResponse)
        onSuccess,
    required FutureOr<void> Function(PaymentFailureResponse failureResponse)
        onFailure,
    String? onlinePaymentToken,
  }) async {
    if (onlinePaymentToken == null) {
      return onFailure(
          PaymentFailureResponse(message: ErrorMessages.khaltiPaymentError));
    }

    final payConfig = KhaltiPayConfig(
      environment: Environment.test,
      publicKey: CommonConstants.khaltiPublicKey,
      pidx: onlinePaymentToken,
      returnUrl: Uri.parse("https://www.khalti.com"),
    );

    final khalti = await Khalti.init(
        payConfig: payConfig,
        onPaymentResult: (paymentResult, khalti) async {
          if (paymentResult.status == 'Completed') {
            await onSuccess(PaymentSuccessResponse(token: onlinePaymentToken));
          } else {
            await onFailure(PaymentFailureResponse(
                message: ErrorMessages.khaltiPaymentError));
          }
          khalti.close(context);
        },
        onMessage: (khalti,
            {description, event, needsPaymentConfirmation, statusCode}) async {
          if (needsPaymentConfirmation != null && needsPaymentConfirmation) {
            await khalti.verify();
          }
          await onFailure(PaymentFailureResponse(
              message: ErrorMessages.khaltiPaymentError));
          khalti.close(context);
        },
        onReturn: () {
          NavigationHelper.pop(context);
        });

    khalti.open(context);
  }
}
