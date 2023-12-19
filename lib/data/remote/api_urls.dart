class ApiUrls {
  static String baseUrl =
      'https://0db1-2400-1a00-b080-5caf-c51a-cf89-4760-a28b.ngrok-free.app/api';

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
  static String updateWishlist = '/wishlists/update';
  static String customerAddress = '/customers/address';
  static String customerOrders = '/orders/customer';
  static String addresses = '/addresses';
  static String shippingMethods = '/shipping-methods';
  static String paymentMethods = '/payment-methods';
  static String orders = '/orders';
  static String customersCountInfo = '/customers/count-info';
}
