class ApiUrls {
  static String baseUrl = 'https://api.flamingo.padmashreemedisales.com.np/api';
  // static String baseUrl = 'http://10.0.2.2:8848/api';

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
  static String latestProducts = '/products/latest';
  static String productSearch = '/products/search';
  static String productSearchSuggestion = '/products/search/suggestions';
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
  static String vendors = '/vendors';
  static String customersCountInfo = '/customers/count-info';
  static String advertisements = '/advertisements/active';
  static String updateFavouriteVendor = '/customer-favourite-vendors/update';
  static String customerFavouriteVendor =
      '/customer-favourite-vendors/customer';
  static String userActivity = '/user-activity';
  static String advertisementActivity = '/advertisement-activity';
  static String trackOrder = '/orders/:id/track';
  static String likedVendorStory = '/product-story/liked-vendor';
  static String viewStory = '/product-story/:id/view';
}
