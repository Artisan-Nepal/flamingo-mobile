// ignore_for_file: unused_field

import 'package:flamingo/feature/product/data/local/product_local.dart';
import 'package:flamingo/feature/product/data/model/product_color.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/feature/product/data/remote/product_remote.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocal _productLocal;
  final ProductRemote _productRemote;

  ProductRepositoryImpl(
      {required ProductLocal productLocal,
      required ProductRemote productRemote})
      : _productLocal = productLocal,
        _productRemote = productRemote;

  @override
  Future<List<ProductColor>> getProductColors() async {
    return _productRemote.getProductColors();
  }
}
