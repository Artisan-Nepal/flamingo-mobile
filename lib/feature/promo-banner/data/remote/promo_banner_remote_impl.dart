import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/promo-banner/data/model/promo_banner.dart';
import 'package:flamingo/feature/promo-banner/data/remote/promo_banner_remote.dart';

class PromoBannerRemoteImpl implements PromoBannerRemote {
  final ApiClient _apiClient;

  PromoBannerRemoteImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<PromoBanner>> getActiveBanners() async {
    final apiResponse = await _apiClient.get(ApiUrls.promoBannersActive);
    return PromoBanner.fromJsonList(apiResponse.data);
  }

  @override
  Future<void> redeemCoupon(String couponId) async {
    await _apiClient.post(ApiUrls.couponRedeem, body: {'couponId': couponId});
  }
}
