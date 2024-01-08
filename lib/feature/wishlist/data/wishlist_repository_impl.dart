// ignore_for_file: unused_field

import 'package:flamingo/data/model/fetch_response.dart';
import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/wishlist/data/local/wishlist_local.dart';
import 'package:flamingo/feature/wishlist/data/model/add_to_wishlist_request.dart';
import 'package:flamingo/feature/wishlist/data/model/wishlist_item.dart';
import 'package:flamingo/feature/wishlist/data/remote/wishilst_remote.dart';
import 'package:flamingo/feature/wishlist/data/wishlist_repository.dart';

class WishlistRepositoryImpl implements VendorRepository {
  final WishlistLocal _wishlistLocal;
  final WishlistRemote _wishlistRemote;
  final AuthRepository _authRepository;

  WishlistRepositoryImpl({
    required WishlistLocal wishlistLocal,
    required WishlistRemote wishlistRemote,
    required AuthRepository authRepository,
  })  : _wishlistLocal = wishlistLocal,
        _authRepository = authRepository,
        _wishlistRemote = wishlistRemote;

  @override
  Future updateWishlist(UpdateWishlistRequest request) async {
    return await _wishlistRemote.updateWishlist(request);
  }

  @override
  Future<FetchResponse<WishlistItem>> getUserWishlist() async {
    final customerId = (await _authRepository.getUserLocal())!.id;
    return await _wishlistRemote.getUserWishlist(customerId);
  }
}
