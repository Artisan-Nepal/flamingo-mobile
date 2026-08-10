class CommonConstants {
  static const int otpLength = 4;
  static const khaltiPublicKey =
      "test_public_key_7e4095f17b5d47f5ae8dd889dc1bfff0";
  static const contactNumber = '9827588389';
  static const contactEmail = 'admin@flamingo.com.np';
  static const notificationChannel = 'flamingo';
  // FCM topic every install subscribes to at launch, regardless of login
  // state - must match the API's PROMOTIONS_TOPIC constant
  // (flamingo-api/src/shared/constant/push-notification-topic.ts).
  static const promotionsTopic = 'promotions';
  // Image search (the camera icon on search bars, opening ImageSearchScreen)
  // is fully implemented but disabled pending relaunch - flip to true to
  // bring the entry points back without touching any other code.
  static const bool imageSearchEnabled = false;
}
