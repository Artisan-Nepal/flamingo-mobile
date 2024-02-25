import 'dart:io';

import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/search/data/model/image_search_request.dart';
import 'package:flamingo/feature/search/data/search_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class ImageSearchViewModel extends ChangeNotifier {
  final SearchRepository _searchRepository;

  ImageSearchViewModel({required SearchRepository searchRepository})
      : _searchRepository = searchRepository;

  Response<List<Product>> _imageSearchUseCase = Response<List<Product>>();
  Response<List<Product>> get imageSearchUseCase => _imageSearchUseCase;

  void setImageSearchUseCase(Response<List<Product>> response) {
    _imageSearchUseCase = response;
    notifyListeners();
  }

  Future<void> imageSearch(File image) async {
    setImageSearchUseCase(Response.loading());
    try {
      final response =
          await _searchRepository.imageSearch(ImageSearchRequest(image: image));
      setImageSearchUseCase(Response.complete(response));
    } catch (exception) {
      setImageSearchUseCase(Response.error(exception));
    }
  }
}
