// ignore_for_file: unused_field

import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/cart/data/cart_repository.dart';
import 'package:flamingo/feature/cart/data/model/add_to_cart_request.dart';
import 'package:flamingo/feature/cart/data/model/cart.dart';
import 'package:flamingo/feature/customer-activity/create_activity_view_model.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/data/model/product_color.dart';
import 'package:flamingo/feature/product/data/model/product_size.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/feature/wishlist/wishlist_view_model.dart';
import 'package:flamingo/shared/constant/advertisement_activity_type.dart';
import 'package:flamingo/shared/constant/user_activity_type.dart';
import 'package:flamingo/shared/enum/lead_source.dart';
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

  Response<ProductDetail> _productUseCase = Response<ProductDetail>();
  late ProductColor _selectedColor;
  late ProductSizeOption _selectedSizeOption;

  Response<ProductDetail> get productUseCase => _productUseCase;
  ProductColor get selectedColor => _selectedColor;
  ProductSizeOption get selectedSizeOption => _selectedSizeOption;

  Response<Cart> _addToCartUseCase = Response<Cart>();

  Response<Cart> get addToCartUseCase => _addToCartUseCase;

  void setAddToCartUseCase(Response<Cart> response) {
    _addToCartUseCase = response;
    notifyListeners();
  }

  void setProductUseCase(Response<ProductDetail> response) {
    _productUseCase = response;
    notifyListeners();
  }

  setProduct(
    String productId,
    ProductDetail? product, {
    LeadSource? leadSource,
    String? advertisementId,
  }) async {
    if (product != null) {
      setProductUseCase(Response.complete(product));
    } else {
      try {
        setProductUseCase(Response.loading());
        final response = await _productRepository.getSingleProduct(productId);
        locator<WishlistViewModel>().initWishlistStatus([response]);
        setProductUseCase(Response.complete(response));
      } catch (exception) {
        setProductUseCase(Response.error(exception));
      }
    }
    if (_productUseCase.hasCompleted) {
      _selectedColor = _productUseCase.data!.variants.first.color;
      _selectedSizeOption = _productUseCase.data!.variants.first.size;

      await locator<CreateActivityViewModel>().createUserActivity(
        vendorId: _productUseCase.data!.seller.vendor!.id,
        productId: productId,
        activityType: UserActivityType.viewProduct,
      );

      if (leadSource != null &&
          advertisementId != null &&
          leadSource.isAdvertisement) {
        locator<CreateActivityViewModel>().createAdvertisementActivity(
          advertisementId: advertisementId,
          productId: productId,
          activityType: AdvertisementActivityType.clickProduct,
        );
      }
    }
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
    for (var variant in _productUseCase.data!.variants) {
      if (!colors.any((color) => color.id == variant.color.id)) {
        colors.add(variant.color);
      }
    }
    return colors;
  }

  List<ProductSizeOption> get availableSizes {
    final List<ProductSizeOption> sizes = [];
    for (var variant in _productUseCase.data!.variants) {
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
    return productUseCase.data!.variants.firstWhere((variant) =>
        variant.color.id == color.id && variant.size.id == size?.id);
  }

  Future<void> addToCart({
    LeadSource? leadSource,
    String? advertisementId,
  }) async {
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

      if (leadSource != null &&
          advertisementId != null &&
          leadSource.isAdvertisement) {
        locator<CreateActivityViewModel>().createAdvertisementActivity(
          advertisementId: advertisementId,
          productId: _productUseCase.data!.id,
          activityType: AdvertisementActivityType.addToCartProduct,
        );
      }
    } catch (exception) {
      setAddToCartUseCase(Response.error(exception));
    }
  }
}
