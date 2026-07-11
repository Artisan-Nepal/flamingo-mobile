class ApiUrls {
  // Environment is chosen at launch via --dart-define-from-file (see config/).
  //   Sim + local:    flutter run --dart-define-from-file=config/local-sim.json
  //   Device + local: flutter run --dart-define-from-file=config/local-device.json
  //   AWS:            flutter run --dart-define-from-file=config/aws.json
  // Default is the AWS URL so a bare `flutter run` / release build never ships localhost.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://saeuxrpkr4.ap-south-1.awsapprunner.com/api',
  );

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
  static String forYou = '/products/for-you';
  static String productSearch = '/products/search';
  static String productSearchSuggestion = '/products/search/suggestions';
  static String productsByVendorId = '/products/vendor/:id';
  static String productsBySellerId = '/products/seller/:id';
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
  static String khaltiInitiate = '/orders/khalti/initiate';
  static String khaltiConfirm = '/orders/khalti/confirm';
  static String couponValidate = '/coupons/validate';
  static String couponRedeem = '/coupons/redeem';
  static String savedCoupons = '/coupons/saved';
  static String promoBannersActive = '/promo-banners/active';
  static String vendors = '/vendors';
  static String vendorSearch = '/vendors/search';
  static String vendorLikes = '/vendors/:id/likes';
  static String customersCountInfo = '/customers/count-info';
  static String advertisements = '/advertisements/active';
  static String updateFavouriteVendor = '/customer-favourite-vendors/update';
  static String customerFavouriteVendor =
      '/customer-favourite-vendors/customer';
  static String userActivity = '/user-activity';
  static String advertisementActivity = '/advertisement-activity';
  static String trackOrder = '/orders/:id/track';
  static String cancelOrder = '/orders/:id/cancel';
  static String likedVendorStory = '/product-story/liked-vendor';
  static String vendorStory = '/product-story/vendor/:id';
  static String viewStory = '/product-story/:id/view';
  static String getRelatedProducts =
      '/recommender/products/:productId/related_products';
  static String imageSearch = '/recommender/image_search';
  static String getUserRecommendations =
      '/recommender/users/:userId/recommend_products';
  static String getCheaperAlternatives =
      '/recommender/products/:productId/cheaper_alternatives';
  static String getInStockAlternatives =
      '/recommender/products/:productId/in_stock_alternatives';
  static String vendorBySellerId = '/vendors/seller/:id';
  static String device = '/devices';
  static String deviceNotificationToken = '/devices/notification-token';
  static String logout = '/auth/logout';
}
