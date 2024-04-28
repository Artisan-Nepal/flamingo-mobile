class PaymentMethod {
  static const String ESEWA = "ESEWA";
  static const String KHALTI = "KHALTI";
  static const String CASH = "CASH_ON_DELIVERY";
  static const String IME_PAY = "IME_PAY";

  static List<String> get online {
    return [PaymentMethod.ESEWA, PaymentMethod.KHALTI, PaymentMethod.IME_PAY];
  }
}
