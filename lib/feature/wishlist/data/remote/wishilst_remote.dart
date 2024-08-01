import 'package:flamingo/data/data.dart';
import 'package:flamingo/data/model/paginated_option.dart';
import 'package:flamingo/feature/wishlist/data/model/add_to_wishlist_request.dart';
import 'package:flamingo/feature/wishlist/data/model/wishlist_item.dart';

abstract class WishlistRemote {
  Future updateWishlist(UpdateWishlistRequest request);
  Future<FetchResponse<WishlistItem>> getUserWishlist(
    String customerId,
    PaginationOption? paginationOption,
  );
}
