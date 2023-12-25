import 'package:flamingo/feature/category/data/category_repository.dart';
import 'package:flamingo/feature/category/data/model/product_category.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class CategorySearchViewModel extends ChangeNotifier {
  final CategoryRepository _categoryRepository;

  CategorySearchViewModel({
    required CategoryRepository categoryRepository,
  }) : _categoryRepository = categoryRepository;

  Response<List<ProductCategory>> _categoriesUseCase =
      Response<List<ProductCategory>>();

  Response<List<ProductCategory>> get categoriesUseCase => _categoriesUseCase;

  void setCategoriesUseCase(Response<List<ProductCategory>> response) {
    _categoriesUseCase = response;
    notifyListeners();
  }

  Future<void> getCategories({bool isRefresh = false}) async {
    try {
      if (!isRefresh) setCategoriesUseCase(Response.loading());
      final response = await _categoryRepository.getAllCategories();
      setCategoriesUseCase(Response.complete(response.rows));
    } catch (exception) {
      if (!isRefresh) setCategoriesUseCase(Response.error(exception));
    }
  }
}
