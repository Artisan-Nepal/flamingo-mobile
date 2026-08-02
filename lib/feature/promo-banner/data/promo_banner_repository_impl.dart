import 'package:flamingo/feature/promo-banner/data/model/coupon_redeem_outcome.dart';
import 'package:flamingo/feature/promo-banner/data/model/promo_banner.dart';
import 'package:flamingo/feature/promo-banner/data/promo_banner_repository.dart';
import 'package:flamingo/feature/promo-banner/data/remote/promo_banner_remote.dart';

class PromoBannerRepositoryImpl implements PromoBannerRepository {
  final PromoBannerRemote _remote;

  PromoBannerRepositoryImpl({required PromoBannerRemote remote})
      : _remote = remote;

  @override
  Future<List<PromoBanner>> getActiveBanners() async {
    return await _remote.getActiveBanners();
  }

  @override
  Future<CouponRedeemOutcome> redeemCoupon(String couponId) async {
    return await _remote.redeemCoupon(couponId);
  }
}
