import 'package:flamingo/feature/category/data/model/category_attribute.dart';
import 'package:flamingo/feature/category/data/model/product_category.dart';

abstract class CategoryRemote {
  Future<List<ProductCategory>> getAllCategories();
  Future<List<ProductCategory>> getCategoriesByParentId(String parentId);
  Future<List<CategoryAttribute>> getCategoryAttributes(String categoryId);
}
