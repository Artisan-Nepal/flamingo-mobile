class ApiUrls {
  static String baseUrl =
      'https://f8d4-2400-1a00-b080-ad39-8d8c-b6b9-5b12-5384.ngrok-free.app/api';

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
  static String products = '/products';
  static String productsByVendorId = '/products/vendor/:id';
  static String productsByCategoryId = '/products/category/:id';
  static String carts = '/carts';
  static String wishlists = '/wishlists';
}
