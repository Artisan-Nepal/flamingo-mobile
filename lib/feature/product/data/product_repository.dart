import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/product/data/model/product.dart';

abstract class ProductRepository {
  Future<FetchResponse<Product>> getVendorProducts(String vendorId);
}
