import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/category/data/model/product_category.dart';

abstract class CategoryRemote {
  Future<FetchResponse<ProductCategory>> getAllCategories();
  Future<List<ProductCategory>> getCategoriesByParentId(String parentId);
}
