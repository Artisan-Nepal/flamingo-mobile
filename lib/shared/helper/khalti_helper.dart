import 'package:flutter/material.dart';

class KhaltiHelper {
  static Future<KhaltiPaymentResponse> pay(
    BuildContext context, {
    required int amount,
    required String productId,
    required String productName,
    String productUrl = 'https://www.khalti.com/#/bazaar',
    String? mobileNumber,
    Map<String, Object>? additionalData,
  }) async {
    return KhaltiPaymentResponse(success: false, message: 'Khalti payment disabled in local dev');
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
