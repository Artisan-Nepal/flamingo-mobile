import 'package:flamingo/feature/product/data/model/product_color.dart';
import 'package:flamingo/feature/product/data/model/product_size.dart';
import 'package:flamingo/feature/product/data/model/product_story.dart';
import 'package:flamingo/feature/upload-file/data/model/upload_file_response.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';

class Product {
  final String id;
  final String title;
  final String body;
  final String status;
  final Vendor vendor;
  final List<String> tags;
  final List<ProductVariant> variants;
  final List<String> images;
  final List<ProductStory> stories;
  final bool isInWishlist;

  Product({
    required this.id,
    required this.title,
    required this.body,
    required this.status,
    required this.vendor,
    required this.tags,
    required this.variants,
    required this.isInWishlist,
    required this.images,
    required this.stories,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        status: json['status'],
        vendor: Vendor.fromJson(json['vendor']),
        tags: List<String>.from(
            json['productToTag'].map((e) => e['productTag']['name'])),
        variants: ProductVariant.fromJsonList(json['variants']),
        images: json['images'] == null
            ? []
            : List<String>.from(json['images'].map((e) => e['imageUrl'])),
        stories: json['productStory'] == null
            ? []
            : ProductStory.fromJsonList(json['productStory']),
        isInWishlist: json['wishlist'] == null
            ? false
            : List.from(json['wishlist']).isNotEmpty,
      );

  static List<Product> fromJsonList(dynamic json) => List<Product>.from(
        json.map(
          (data) => Product.fromJson(data),
        ),
      );
}

class ProductVariant {
  final String id;
  final String sku;
  final int quantityInStock;
  final int price;
  final String productId;
  final ProductColor color;
  final ProductSizeOption size;
  final List<ProductAttributeResponse> attributes;
  final UploadFileResponse? image;

  ProductVariant({
    required this.id,
    required this.sku,
    required this.quantityInStock,
    required this.price,
    required this.productId,
    required this.color,
    required this.attributes,
    required this.image,
    required this.size,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        id: json["id"],
        sku: json['sku'],
        quantityInStock: json['quantityInStock'],
        price: json['price'],
        productId: json['productId'],
        size: ProductSizeOption.fromJson(json['productSizeOption']),
        color: ProductColor.fromJson(
            json['productVariantColor'][0]['productColor']),
        attributes: ProductAttributeResponse.fromJsonList(
            json['productAttributeOption']),
        image: json['productVariantColor'][0]['image'] == null
            ? null
            : UploadFileResponse.fromJson(
                json['productVariantColor'][0]['image'],
              ),
      );

  static List<ProductVariant> fromJsonList(dynamic json) =>
      List<ProductVariant>.from(
        json.map(
          (data) => ProductVariant.fromJson(data),
        ),
      );
}

class ProductAttributeResponse {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final ProductAttributeOptionResponse option;

  ProductAttributeResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.option,
  });

  factory ProductAttributeResponse.fromJson(Map<String, dynamic> json) {
    final attribute = json['attributeOption']['attribute'];
    return ProductAttributeResponse(
      id: attribute["id"],
      name: attribute["name"],
      description: attribute["description"] ?? "",
      categoryId: attribute["categoryId"],
      option: ProductAttributeOptionResponse.fromJson(json['attributeOption']),
    );
  }

  static List<ProductAttributeResponse> fromJsonList(dynamic json) =>
      List<ProductAttributeResponse>.from(
        json.map(
          (data) => ProductAttributeResponse.fromJson(data),
        ),
      );
}

class ProductAttributeOptionResponse {
  final String id;
  final String value;
  final String valueType;

  ProductAttributeOptionResponse({
    required this.id,
    required this.value,
    required this.valueType,
  });

  factory ProductAttributeOptionResponse.fromJson(Map<String, dynamic> json) =>
      ProductAttributeOptionResponse(
        id: json["id"],
        value: json["value"],
        valueType: json["valueType"],
      );
}
