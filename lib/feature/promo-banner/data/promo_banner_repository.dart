import 'package:flamingo/feature/promo-banner/data/model/coupon_redeem_outcome.dart';
import 'package:flamingo/feature/promo-banner/data/model/promo_banner.dart';

abstract class PromoBannerRepository {
  Future<List<PromoBanner>> getActiveBanners();
  Future<CouponRedeemOutcome> redeemCoupon(String couponId);
}
