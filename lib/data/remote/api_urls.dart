class ApiUrls {
  static String baseUrl =
      'https://867e-2400-1a00-b080-ad39-f1e7-ca35-9f5f-f89b.ngrok-free.app/api';

  // AUTH
  static String sendLoginOtp = '/auth/send-otp';
  static String resendLoginOtp = '/auth/resend-otp';
  static String verifyLoginOtp = '/auth/login/verify-otp';

  static String customers = '/customers';
  static String categories = '/categories';
  static String uploadFiles = '/upload-files';
  static String provinces = '/provinces';
  static String citiesbyProvince = '/cities/province';
  static String areasByCity = '/areas/city';
  static String productsByVendorId = '/products/vendor/:id';
}
