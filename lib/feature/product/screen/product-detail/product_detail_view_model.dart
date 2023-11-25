// ignore_for_file: unused_field

import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/model/product_color.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flutter/material.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  ProductDetailViewModel({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  late Product _product;
  late ProductColor _selectedColor;
  late ProductAttributeOptionResponse _selectedSize;

  Product get product => _product;
  ProductColor get selectedColor => _selectedColor;
  ProductAttributeOptionResponse get selectedSize => _selectedSize;

  setProduct(Product? product) {
    if (product != null) {
      _product = product;
    } else {
      // get from api
    }
    _selectedColor = _product.variants.first.color;
    _selectedSize = _product.variants.first.attributes.first.option;
  }

  setSelectedColor(ProductColor color) {
    _selectedColor = color;
    notifyListeners();
  }

  setSelectedSize(ProductAttributeOptionResponse size) {
    _selectedSize = size;
    notifyListeners();
  }

  List<ProductColor> get availableColors {
    final List<ProductColor> colors = [];
    for (var variant in _product.variants) {
      if (!colors.any((color) => color.id == variant.color.id)) {
        colors.add(variant.color);
      }
    }
    return colors;
  }

  List<ProductAttributeOptionResponse> get availableSizes {
    final List<ProductAttributeOptionResponse> sizes = [];
    for (var variant in _product.variants) {
      if (!sizes.any((size) => size.id == variant.attributes.first.option.id)) {
        sizes.add(variant.attributes.first.option);
      }
    }
    return sizes;
  }

  ProductVariant get selectedVariant {
    return getVariantByColorAndSize(_selectedColor, _selectedSize);
  }

  ProductVariant getVariantByColorAndSize(
      ProductColor color, ProductAttributeOptionResponse size) {
    return product.variants.firstWhere((variant) =>
        variant.color.id == color.id &&
        variant.attributes.first.option.id == size.id);
  }

  Future<void> addToBag() async {}
}
