class PaymentMethod {
  static const String ESEWA = "ESEWA";
  static const String KHALTI = "KHALTI";
  static const String CASH = "CASH_ON_DELIVERY";
  static const String IME_PAY = "IME_PAY";

  // Deep link the Khalti checkout WebView intercepts to detect payment
  // completion. Must exactly match the API's KHALTI_RETURN_URL env var
  // (flamingo-api/env.example) - never actually loaded, just recognized.
  static const String khaltiReturnUrlScheme = "flamingo-khalti://return";
}
