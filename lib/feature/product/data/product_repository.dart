import 'package:flamingo/feature/product/data/model/product_color.dart';

abstract class ProductRepository {
  Future<List<ProductColor>> getProductColors();
}
