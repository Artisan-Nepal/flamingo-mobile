import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/wishlist/data/local/wishlist_local.dart';

class WishlistLocalImpl implements WishlistLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  WishlistLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
