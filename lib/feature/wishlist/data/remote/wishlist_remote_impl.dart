import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/wishlist/data/model/add_to_wishlist_request.dart';
import 'package:flamingo/feature/wishlist/data/model/wishlist_item.dart';
import 'package:flamingo/feature/wishlist/data/remote/wishilst_remote.dart';

class WishlistRemoteImpl implements WishlistRemote {
  final ApiClient _apiClient;

  WishlistRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future updateWishlist(UpdateWishlistRequest request) async {
    await _apiClient.post(ApiUrls.updateWishlist, body: request.toJson());
  }

  @override
  Future<FetchResponse<WishlistItem>> getUserWishlist(String customerId) async {
    final url = '${ApiUrls.wishlists}/customer/$customerId';
    final apiResponse = await _apiClient.get(url);
    return FetchResponse.fromJson(
      apiResponse.data,
      WishlistItem.fromJsonList,
    );
  }
}
