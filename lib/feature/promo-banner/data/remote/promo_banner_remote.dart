import 'package:flamingo/feature/promo-banner/data/model/promo_banner.dart';

abstract class PromoBannerRemote {
  Future<List<PromoBanner>> getActiveBanners();
  Future<void> redeemCoupon(String couponId);
}
