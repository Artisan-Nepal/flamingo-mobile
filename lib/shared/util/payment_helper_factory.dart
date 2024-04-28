import 'package:flamingo/shared/constant/payment_method.dart';
import 'package:flamingo/shared/helper/payment/esewa_payment_helper.dart';
import 'package:flamingo/shared/helper/payment/payment_helper.dart';
import 'package:flamingo/shared/shared.dart';

class PaymentHelperFactory {
  static PaymentHelper create(String paymentCode) {
    if (paymentCode == PaymentMethod.KHALTI) {
      return KhaltiPaymentHelper();
    } else if (paymentCode == PaymentMethod.ESEWA) {
      return EsewaPaymentHelper();
    } else {
      throw Exception(ErrorMessages.defaultError);
    }
  }
}
