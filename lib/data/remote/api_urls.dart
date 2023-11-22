class ApiUrls {
  static String baseUrl =
      'https://5259-2400-1a00-b080-ad39-f594-b3a5-5c6d-cfb4.ngrok-free.app/api';

  // AUTH
  static String sendLoginOtp = '/auth/send-otp';
  static String resendLoginOtp = '/auth/resend-otp';
  static String verifyLoginOtp = '/auth/login/verify-otp';

  static String customers = '/customers';
  static String categories = '/categories';
}
