import 'package:flamingo/feature/promo-banner/data/model/coupon_redeem_outcome.dart';
import 'package:flamingo/feature/promo-banner/data/model/promo_banner.dart';
import 'package:flamingo/feature/promo-banner/data/promo_banner_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class PromoBannerViewModel extends ChangeNotifier {
  final PromoBannerRepository _repository;

  PromoBannerViewModel({required PromoBannerRepository repository})
      : _repository = repository;

  Response<List<PromoBanner>> _getBannersUseCase = Response<List<PromoBanner>>();
  Response<List<PromoBanner>> get getBannersUseCase => _getBannersUseCase;

  void _setBanners(Response<List<PromoBanner>> response) {
    _getBannersUseCase = response;
    notifyListeners();
  }

  Future<void> getBanners() async {
    try {
      _setBanners(Response.loading());
      final banners = await _repository.getActiveBanners();
      _setBanners(Response.complete(banners));
    } catch (exception) {
      _setBanners(Response.error(exception));
    }
  }

  // Saves the coupon to the customer's wallet. Returns the outcome (saved /
  // already redeemed / already used / failed) so the caller can toast honestly
  // instead of always claiming success.
  Future<CouponRedeemOutcome> redeem(String couponId) async {
    try {
      return await _repository.redeemCoupon(couponId);
    } catch (_) {
      return CouponRedeemOutcome.failed;
    }
  }
}
