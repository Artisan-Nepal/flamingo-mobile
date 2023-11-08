// ignore_for_file: unused_field

import 'package:flamingo/feature/category/data/category_repository.dart';
import 'package:flamingo/feature/category/data/local/category_local.dart';
import 'package:flamingo/feature/category/data/model/category_attribute.dart';
import 'package:flamingo/feature/category/data/model/product_category.dart';
import 'package:flamingo/feature/category/data/remote/category_remote.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocal _categoryLocal;
  final CategoryRemote _categoryRemote;

  CategoryRepositoryImpl(
      {required CategoryLocal categoryLocal,
      required CategoryRemote categoryRemote})
      : _categoryLocal = categoryLocal,
        _categoryRemote = categoryRemote;

  @override
  Future<List<ProductCategory>> getCategoriesByParentId(String parentId) async {
    return await _categoryRemote.getCategoriesByParentId(parentId);
  }

  @override
  Future<List<ProductCategory>> getAllCategories() async {
    return await _categoryRemote.getAllCategories();
  }

  @override
  Future<List<CategoryAttribute>> getCategoryAttributes(
      String categoryId) async {
    return await _categoryRemote.getCategoryAttributes(categoryId);
  }
}
