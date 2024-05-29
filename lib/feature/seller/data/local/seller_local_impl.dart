import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/seller/data/local/seller_local.dart';

class SellerLocalImpl implements SellerLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  SellerLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
