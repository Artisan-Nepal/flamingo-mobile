import 'package:flamingo/feature/category/data/category_repository.dart';
import 'package:flamingo/feature/category/data/model/category_attribute.dart';
import 'package:flamingo/feature/category/data/model/product_category.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ProductListScreenModel extends ChangeNotifier {
  final CategoryRepository _categoryRepository;

  ProductListScreenModel({
    required CategoryRepository categoryRepository,
  }) : _categoryRepository = categoryRepository;

  final List<ProductCategory> _categories = [];
  final List<ProductCategory> _subCategories = [];
  ProductCategory? _selectedTopLevelCategory;
  ProductCategory? _selectedCategory;
  ProductCategory? _selectedSubCategory;

  final List<CatgeoryAttributeOption> _selectedAttributeOptions = [];

  Response<List<ProductCategory>> _topLevelCategoriesUseCase =
      Response<List<ProductCategory>>();

  final topLevelCategoriesWithChildren = <ProductCategory>[];
  final topLevelCategoriesWithoutChildren = <ProductCategory>[];

  Response<List<CategoryAttribute>> _categoryAttributeUseCase =
      Response<List<CategoryAttribute>>();
  List<ProductCategory> get categories => _categories;
  List<ProductCategory> get subCategories => _subCategories;
  ProductCategory? get selectedTopLevelCategory => _selectedTopLevelCategory;
  ProductCategory? get selectedCategory => _selectedCategory;
  ProductCategory? get selectedSubCategory => _selectedSubCategory;

  List<CatgeoryAttributeOption> get selectedAttributeOptions =>
      _selectedAttributeOptions;

  Response<List<ProductCategory>> get topLevelCategoriesUseCase =>
      _topLevelCategoriesUseCase;

  Response<List<CategoryAttribute>> get categoryAttributeUseCase =>
      _categoryAttributeUseCase;

  bool get hasSelectedCategory {
    if (selectedSubCategory != null) {
      return true;
    }

    if (selectedCategory != null && selectedCategory!.children == null) {
      return true;
    }

    if (selectedTopLevelCategory != null &&
        selectedTopLevelCategory!.children == null) {
      return true;
    }

    return false;
  }

  ProductCategory get selectedProductCatgeory {
    return _selectedSubCategory ??
        _selectedCategory ??
        _selectedTopLevelCategory!;
  }

  void initProductAddition() async {
    await getTopLevelCategories();
  }

  void setTopLevelCategoriesUseCase(Response<List<ProductCategory>> response) {
    _topLevelCategoriesUseCase = response;
    notifyListeners();
  }

  void setCategoryAttributesUseCase(
      Response<List<CategoryAttribute>> response) {
    _categoryAttributeUseCase = response;
    notifyListeners();
  }

  void setSelectedTopLevelCategory(ProductCategory category) {
    _selectedTopLevelCategory = category;
    _selectedCategory = null;
    notifyListeners();
  }

  void setSelectedCategory(ProductCategory category) {
    _selectedCategory = category;
    _selectedSubCategory = null;
    notifyListeners();
  }

  void setSelectedSubCategory(ProductCategory subCategory) {
    _selectedSubCategory = subCategory;
    notifyListeners();
  }

  void addSelectedAttributeOption(CatgeoryAttributeOption option) {
    _selectedAttributeOptions.add(option);
    notifyListeners();
  }

  void removeSelectedAttributeOption(String optionId) {
    _selectedAttributeOptions.removeWhere((option) => option.id == optionId);
    notifyListeners();
  }

  void gettoplevelCategoriesfromgivencategory(
      ProductCategory productCategory) async {
    final response = productCategory.children;
    //response[i].name gives men/women, //response[i].children gives the subcategories
    if (response != null) {
      for (final category in response) {
        print(category.name);
        if (category.children != null) {
          print(category.children);
          topLevelCategoriesWithChildren.add(category);
        } else {
          topLevelCategoriesWithoutChildren.add(category);
        }
      }
      setTopLevelCategoriesUseCase(Response.complete(response));
    }
  }

  Future<void> getTopLevelCategories() async {
    try {
      setTopLevelCategoriesUseCase(Response.loading());
      final response = await _categoryRepository.getAllCategories();
      //response[i].name gives men/women, //response[i].children gives the subcategories
      for (final category in response) {
        if (category.children != null) {
          topLevelCategoriesWithChildren.add(category);
        } else {
          topLevelCategoriesWithoutChildren.add(category);
        }
      }
      setTopLevelCategoriesUseCase(Response.complete(response));
    } catch (exception) {
      setTopLevelCategoriesUseCase(Response.error(exception));
    }
  }

  Future<void> getCategoryAttributes() async {
    try {
      setCategoryAttributesUseCase(Response.loading());
      final response = await _categoryRepository
          .getCategoryAttributes(selectedProductCatgeory.id);
      setCategoryAttributesUseCase(Response.complete(response));
    } catch (exception) {
      setCategoryAttributesUseCase(Response.error(exception));
    }
  }
}
