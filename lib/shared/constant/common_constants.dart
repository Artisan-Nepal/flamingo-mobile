class CommonConstants {
  static const int otpLength = 4;
  static const khaltiPublicKey =
      "test_public_key_7e4095f17b5d47f5ae8dd889dc1bfff0";
  static const contactNumber = '9840382035';
  static const contactEmail = 'flamingoo202310@gmail.com';
  static const notificationChannel = 'flamingo';
  // FCM topic every install subscribes to at launch, regardless of login
  // state - must match the API's PROMOTIONS_TOPIC constant
  // (flamingo-api/src/shared/constant/push-notification-topic.ts).
  static const promotionsTopic = 'promotions';
}
