import 'package:flamingo/feature/product/data/model/product.dart';

abstract class ProductRemote {
  Future<List<Product>> getProductList();
}
