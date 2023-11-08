import 'package:flamingo/data/remote/rest/api_client.dart';
import 'package:flamingo/feature/category/data/model/category_attribute.dart';
import 'package:flamingo/feature/category/data/model/product_category.dart';
import 'package:flamingo/feature/category/data/remote/category_remote.dart';

class CategoryRemoteImpl implements CategoryRemote {
  // ignore: unused_field
  final ApiClient _apiClient;

  CategoryRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<ProductCategory>> getCategoriesByParentId(String parentId) async {
    return [
      ProductCategory(id: '3', name: 'Tops'),
      ProductCategory(id: '4', name: 'Bottoms'),
      ProductCategory(id: '5', name: 'Outwear'),
      ProductCategory(id: '6', name: 'Footwear'),
      ProductCategory(id: '7', name: 'Accessories'),
      ProductCategory(id: '8', name: 'Tailoring'),
    ];
  }

  @override
  Future<List<ProductCategory>> getAllCategories() async {
    return [
      ProductCategory(
        id: '1',
        name: 'Menswear',
        children: [
          ProductCategory(id: '3', name: 'Tops'),
          ProductCategory(
            id: '4',
            name: 'Bottoms',
            children: [
              ProductCategory(id: '15', name: 'Casual Pants'),
              ProductCategory(id: '16', name: 'Cropped Pants'),
              ProductCategory(id: '17', name: 'Leggings'),
              ProductCategory(id: '18', name: 'Swimwear'),
            ],
          ),
          ProductCategory(id: '5', name: 'Outwear'),
          ProductCategory(id: '6', name: 'Footwear'),
          ProductCategory(id: '7', name: 'Accessories'),
          ProductCategory(id: '8', name: 'Tailoring'),
        ],
      ),
      ProductCategory(
        id: '2',
        name: 'Womenswear',
        children: [
          ProductCategory(
            id: '3',
            name: 'Tops',
            children: [
              ProductCategory(id: '15', name: 'Blouses'),
              ProductCategory(id: '16', name: 'Crop Tops'),
              ProductCategory(id: '17', name: 'Tank Tops'),
              ProductCategory(id: '17', name: 'Sweatshirts'),
            ],
          ),
          ProductCategory(id: '9', name: 'Bottoms'),
          ProductCategory(id: '10', name: 'Outwear'),
          ProductCategory(id: '11', name: 'Footwear'),
          ProductCategory(id: '12', name: 'Accessories'),
          ProductCategory(id: '13', name: 'Bags & Luggage'),
          ProductCategory(id: '14', name: 'Jewelry'),
        ],
      ),
    ];
  }

  @override
  Future<List<CategoryAttribute>> getCategoryAttributes(
      String categoryId) async {
    return [
      CategoryAttribute(
        id: '1',
        name: 'Size',
        description: 'Size',
        categoryId: '1',
        options: [
          CatgeoryAttributeOption(
            id: '1',
            attributeId: '1',
            value: 'XS',
            valueType: 'string',
          ),
          CatgeoryAttributeOption(
            id: '2',
            attributeId: '1',
            value: 'S',
            valueType: 'string',
          ),
          CatgeoryAttributeOption(
            id: '3',
            attributeId: '1',
            value: 'L',
            valueType: 'string',
          ),
          CatgeoryAttributeOption(
            id: '4',
            attributeId: '1',
            value: 'XL',
            valueType: 'string',
          ),
          CatgeoryAttributeOption(
            id: '5',
            attributeId: '1',
            value: 'XXL',
            valueType: 'string',
          ),
        ],
      )
    ];
  }
}
