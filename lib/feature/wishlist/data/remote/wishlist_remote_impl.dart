import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/wishlist/data/model/add_to_wishlist_request.dart';
import 'package:flamingo/feature/wishlist/data/model/wishlist_item.dart';
import 'package:flamingo/feature/wishlist/data/remote/wishilst_remote.dart';

class WishlistRemoteImpl implements WishlistRemote {
  final ApiClient _apiClient;

  WishlistRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<WishlistItem> addToWishList(AddToWishlistRequest request) async {
    final apiResponse =
        await _apiClient.post(ApiUrls.carts, body: request.toJson());
    return WishlistItem.fromJson(apiResponse.data);
  }
}
