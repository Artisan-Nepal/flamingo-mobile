import 'package:flamingo/feature/product/data/model/product_color.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MainHometScreenModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  MainHometScreenModel({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;
  List<Product> _products = [];

  Future<List<Product>> getlistofproducts() async {
    final List<Product> ListofProducts =
        await _productRepository.getProductList();
    _products = ListofProducts;
    print(_products.length);
    return _products;
  }
}
