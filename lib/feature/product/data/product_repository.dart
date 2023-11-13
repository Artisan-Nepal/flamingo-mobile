import 'package:flamingo/feature/product/data/model/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProductList();
}
