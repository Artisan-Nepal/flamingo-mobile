import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flutter/material.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  ProductDetailViewModel({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;
  late Product _product;

  Product get product => _product;

  setProduct(Product? product) {
    if (product != null) {
      _product = product;
    } else {
      // get from api
    }
  }
}
