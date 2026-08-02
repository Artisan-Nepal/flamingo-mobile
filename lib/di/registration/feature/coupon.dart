import 'package:flamingo/feature/coupon/screen/coupon-listing/coupon_listing_view_model.dart';
import 'package:flamingo/feature/order/data/order_repository.dart';
import 'package:get_it/get_it.dart';

void registerCouponFeature(GetIt locator) {
  // Reuses OrderRepository, which already exposes getSavedCoupons()
  // (GET /coupons/saved). Registered after the order feature.
  locator.registerFactory<CouponListingViewModel>(
    () => CouponListingViewModel(
      orderRepository: locator<OrderRepository>(),
    ),
  );
}
