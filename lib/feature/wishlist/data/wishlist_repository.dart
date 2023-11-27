import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/wishlist/data/model/add_to_wishlist_request.dart';
import 'package:flamingo/feature/wishlist/data/model/wishlist_item.dart';

abstract class WishlistRepository {
  Future updateWishlist(UpdateWishlistRequest request);
  Future<FetchResponse<WishlistItem>> getUserWishlist();
}
