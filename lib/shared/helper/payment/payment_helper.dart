import 'dart:async';

import 'package:flutter/material.dart';

abstract class PaymentHelper {
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
  });
}

class PaymentSuccessResponse {
  final String token;

  PaymentSuccessResponse({
    required this.token,
  });
}

class PaymentFailureResponse {
  final String message;

  PaymentFailureResponse({
    required this.message,
  });
}
