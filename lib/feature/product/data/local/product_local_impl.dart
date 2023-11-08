import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/product/data/local/product_local.dart';

class ProductLocalImpl implements ProductLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  ProductLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
