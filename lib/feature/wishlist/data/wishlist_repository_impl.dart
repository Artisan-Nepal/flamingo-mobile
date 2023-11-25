// ignore_for_file: unused_field

import 'package:flamingo/feature/wishlist/data/local/wishlist_local.dart';
import 'package:flamingo/feature/wishlist/data/model/add_to_wishlist_request.dart';
import 'package:flamingo/feature/wishlist/data/model/wishlist_item.dart';
import 'package:flamingo/feature/wishlist/data/remote/wishilst_remote.dart';
import 'package:flamingo/feature/wishlist/data/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocal _wishlistLocal;
  final WishlistRemote _wishlistRemote;

  WishlistRepositoryImpl({
    required WishlistLocal wishlistLocal,
    required WishlistRemote wishlistRemote,
  })  : _wishlistLocal = wishlistLocal,
        _wishlistRemote = wishlistRemote;

  @override
  Future<WishlistItem> addToWishlist(AddToWishlistRequest request) async {
    return await _wishlistRemote.addToWishList(request);
  }
}
