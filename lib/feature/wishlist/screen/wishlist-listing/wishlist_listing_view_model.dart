import 'package:flamingo/data/data.dart';
import 'package:flamingo/data/model/paginated_option.dart';
import 'package:flamingo/feature/wishlist/data/model/wishlist_item.dart';
import 'package:flamingo/feature/wishlist/data/wishlist_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class WishlistListingViewModel extends ChangeNotifier {
  final WishlistRepository _wishlistRepository;

  WishlistListingViewModel({required WishlistRepository wishlistRepository})
      : _wishlistRepository = wishlistRepository;

  Response<FetchResponse<WishlistItem>> _wishlistUseCase =
      Response<FetchResponse<WishlistItem>>();
  Response<FetchResponse<WishlistItem>> get wishlistUseCase => _wishlistUseCase;

  void setWishlistUseCase(Response<FetchResponse<WishlistItem>> response) {
    _wishlistUseCase = response;
    notifyListeners();
  }

  void appendWishlistUseCase(FetchResponse<WishlistItem> response) {
    _wishlistUseCase.data!.rows.addAll(response.rows);
    _wishlistUseCase.data!.metadata = response.metadata;
    notifyListeners();
  }

  Future<void> getWishlist({
    bool updateState = true,
    bool paginate = false,
    PaginationOption? paginationOption,
  }) async {
    try {
      if (updateState) setWishlistUseCase(Response.loading());
      final response =
          await _wishlistRepository.getUserWishlist(paginationOption);
      if (paginate) {
        appendWishlistUseCase(response);
      } else {
        setWishlistUseCase(Response.complete(response));
      }
    } catch (exception) {
      if (updateState) setWishlistUseCase(Response.error(exception));
    }
  }

  void removeFromWishlistState(String productId) {
    wishlistUseCase.data?.rows
        .removeWhere((element) => element.product.id == productId);
    notifyListeners();
  }
}
