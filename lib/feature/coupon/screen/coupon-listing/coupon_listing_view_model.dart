import 'package:flamingo/feature/order/data/model/saved_coupon.dart';
import 'package:flamingo/feature/order/data/order_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

/// Backs the Coupons wallet under Profile - the coupons the customer has saved
/// (by tapping promo banners) that are still redeemable. Reuses the same
/// `/coupons/saved` endpoint the checkout suggestions use.
class CouponListingViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository;

  CouponListingViewModel({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Response<List<SavedCoupon>> _couponsUseCase = Response<List<SavedCoupon>>();
  Response<List<SavedCoupon>> get couponsUseCase => _couponsUseCase;

  void _set(Response<List<SavedCoupon>> response) {
    _couponsUseCase = response;
    notifyListeners();
  }

  Future<void> getCoupons({bool updateState = true}) async {
    try {
      if (updateState) _set(Response.loading());
      final coupons = await _orderRepository.getSavedCoupons();
      _set(Response.complete(coupons));
    } catch (exception) {
      if (updateState) _set(Response.error(exception));
    }
  }
}
