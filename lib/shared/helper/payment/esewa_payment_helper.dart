import 'dart:async';
import 'package:flamingo/shared/helper/payment/payment_helper.dart';
import 'package:flutter/material.dart';

class EsewaPaymentHelper implements PaymentHelper {
  pay(
    BuildContext context, {
    required int amount,
    required String checkoutId,
    required String checkoutName,
    required FutureOr<void> Function(PaymentSuccessResponse successResponse)
        onSuccess,
    required FutureOr<void> Function(PaymentFailureResponse failureResponse)
        onFailure,
    String? onlinePaymentToken,
  }) async {}
}
