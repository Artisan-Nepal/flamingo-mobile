class LocalStorageKeys {
  static const String isLoggedIn = "is_logged_in";
  static const String isFirstTime = "is_first_time";
  static const String accessToken = "access_token";
  static const String refreshToken = "refresh_token";
  static const String themeMode = 'theme_mode';
  static const String user = 'user';
  static const String searchedTextHistory = 'searched_text_history';
  static const String guestId = 'guest_id';
  static const String pendingKhaltiPidx = 'pending_khalti_pidx';
  static const String pendingKhaltiPidxExpiresAt = 'pending_khalti_pidx_expires_at';
  static const String measurementsBannerFirstShownAt = 'measurements_banner_first_shown_at';
  // Last checkout selections, re-applied to default the next checkout (payment
  // method is deliberately NOT remembered - the customer may pay differently
  // each time).
  static const String lastShippingAddressId = 'last_shipping_address_id';
  static const String lastBillingAddressId = 'last_billing_address_id';
  static const String lastShippingMethodId = 'last_shipping_method_id';
}
