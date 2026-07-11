import 'package:flamingo/feature/product/data/model/for_you_section.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

/// Drives the home "For You" feed: category-grouped product rows built from the
/// user's own activity by the backend (/products/for-you). Behavioral, not the
/// image-similarity recommender, so it spans the variety of categories the user
/// has interacted with rather than look-alikes of a single product.
class ForYouViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  ForYouViewModel({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  Response<List<ForYouSection>> _getForYouUseCase =
      Response<List<ForYouSection>>();

  Response<List<ForYouSection>> get getForYouUseCase => _getForYouUseCase;

  void _setUseCase(Response<List<ForYouSection>> response) {
    _getForYouUseCase = response;
    notifyListeners();
  }

  Future<void> getForYou({bool isRefresh = false}) async {
    try {
      if (!isRefresh) _setUseCase(Response.loading());
      final sections = await _productRepository.getForYouSections();
      _setUseCase(Response.complete(sections));
    } catch (exception) {
      if (!isRefresh) _setUseCase(Response.error(exception));
    }
  }
}
