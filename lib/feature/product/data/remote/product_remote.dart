import 'package:flamingo/feature/product/data/model/product_color.dart';

abstract class ProductRemote {
  Future<List<ProductColor>> getProductColors();
}
