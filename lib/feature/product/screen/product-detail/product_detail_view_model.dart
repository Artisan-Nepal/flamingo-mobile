// ignore_for_file: unused_field

import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/cart/data/cart_repository.dart';
import 'package:flamingo/feature/cart/data/model/add_to_cart_request.dart';
import 'package:flamingo/feature/cart/data/model/cart.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/model/product_color.dart';
import 'package:flamingo/feature/product/data/model/product_size.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;
  final CartRepository _cartRepository;

  ProductDetailViewModel({
    required ProductRepository productRepository,
    required CartRepository cartRepository,
  })  : _productRepository = productRepository,
        _cartRepository = cartRepository;

  late Product _product;
  late ProductColor _selectedColor;
  late ProductSizeOption _selectedSizeOption;

  Product get product => _product;
  ProductColor get selectedColor => _selectedColor;
  ProductSizeOption get selectedSizeOption => _selectedSizeOption;

  Response<Cart> _addToCartUseCase = Response<Cart>();

  Response<Cart> get addToCartUseCase => _addToCartUseCase;

  void setAddToCartUseCase(Response<Cart> response) {
    _addToCartUseCase = response;
    notifyListeners();
  }

  setProduct(Product? product) {
    if (product != null) {
      _product = product;
    } else {
      // get from api
    }
    _selectedColor = _product.variants.first.color;

    _selectedSizeOption = _product.variants.first.size;
  }

  setSelectedColor(ProductColor color) {
    _selectedColor = color;
    notifyListeners();
  }

  setSelectedSize(ProductSizeOption size) {
    _selectedSizeOption = size;
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

  List<ProductSizeOption> get availableSizes {
    final List<ProductSizeOption> sizes = [];
    for (var variant in _product.variants) {
      if (!sizes.any((size) => size.id == variant.size.id)) {
        sizes.add(variant.size);
      }
    }
    return sizes;
  }

  ProductVariant get selectedVariant {
    return getVariantByColorAndSize(_selectedColor, _selectedSizeOption);
  }

  ProductVariant getVariantByColorAndSize(
      ProductColor color, ProductSizeOption? size) {
    return product.variants.firstWhere((variant) =>
        variant.color.id == color.id && variant.size.id == size?.id);
  }

  Future<void> addToCart() async {
    try {
      setAddToCartUseCase(Response.loading());
      final response = await _cartRepository.addToCart(
        AddToCartRequest(
          productVariantId: selectedVariant.id,
          quantity: 1,
        ),
      );
      locator<CustomerActivityViewModel>().getCustomerCountInfo();
      setAddToCartUseCase(Response.complete(response));
    } catch (exception) {
      setAddToCartUseCase(Response.error(exception));
    }
  }
}
