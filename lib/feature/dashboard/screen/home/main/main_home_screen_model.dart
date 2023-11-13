import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/shared/shared.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MainHometScreenModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  MainHometScreenModel({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;
  List<Product> _products = [];
  Response<List<Product>> _listofproducts = Response<List<Product>>();
  Response<List<Product>> get listofproducts => _listofproducts;

  // Response<List<Product>> _listofproducts = Response<List<Product>>();
  // Response<List<Product>> get listofproducts => _listofproducts;
  // void setlistofproducts(Response<List<Product>> response) {
  //   _listofproducts = response;
  //   notifyListeners();
  // }
  // setlistofproducts(Response.loading());
  // job done
  // setlistofproducts(Response.complete(ListofProducts));

  void setlistofproducts(Response<List<Product>> response) {
    _listofproducts = response;
    notifyListeners();
  }

  Future<void> getlistofproducts() async {
    setlistofproducts(Response.loading());
    final List<Product> ListofProducts =
        await _productRepository.getProductList();
    _products = ListofProducts;
    print(_products.length);
    setlistofproducts(Response.complete(ListofProducts));
  }
}
