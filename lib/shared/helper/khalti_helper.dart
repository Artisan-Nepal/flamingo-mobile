import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class KhaltiHelper {
  static Future<KhaltiPaymentResponse> pay(
    BuildContext context, {
    required int amount,
    required String productId,
    required String productName,
    String productUrl = 'https://www.khalti.com/#/bazaar',
    required String mobileNumber,
    Map<String, Object>? additionalData,
  }) async {
    late KhaltiPaymentResponse khaltiPaymentResponse;

    final config = PaymentConfig(
        amount: amount,
        productIdentity: productId,
        productName: productName,
        productUrl: 'https://www.khalti.com/#/bazaar',
        mobile: mobileNumber,
        additionalData: additionalData);
    await KhaltiScope.of(context).pay(
      config: config,
      preferences: [PaymentPreference.khalti],
      onSuccess: (data) {
        khaltiPaymentResponse = KhaltiPaymentResponse(
          success: true,
          token: data.token,
        );
      },
      onFailure: (data) {
        khaltiPaymentResponse = KhaltiPaymentResponse(
          success: false,
          message: data.message,
        );
      },
      onCancel: () {
        Fluttertoast.showToast(msg: "Khalti payment was cancelled.");
      },
    );

    return khaltiPaymentResponse;
  }
}

class KhaltiPaymentResponse {
  final String? token;
  final bool success;
  final String message;

  KhaltiPaymentResponse({
    required this.success,
    this.token,
    this.message = '',
  });
}
