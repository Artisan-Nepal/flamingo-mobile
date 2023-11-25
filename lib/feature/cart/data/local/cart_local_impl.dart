import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/cart/data/local/cart_local.dart';

class CartLocalImpl implements CartLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  CartLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
