import 'package:flamingo/feature/product/data/model/product_color.dart';
import 'package:flamingo/feature/product/data/model/product_size.dart';
import 'package:flamingo/feature/product-story/data/model/product_story.dart';
import 'package:flamingo/feature/upload-file/data/model/upload_file_response.dart';
import 'package:flamingo/feature/vendor/data/model/seller.dart';

class ProductDetail {
  final String id;
  final String title;
  final String body;
  final String status;
  final List<String> tags;
  final List<ProductVariant> variants;
  final List<String> images;
  final List<ProductStory> stories;
  final bool isInWishlist;
  final String? details;
  final Seller seller;
  final String? categoryName;
  // Size & fit fields (SIZE_AND_FIT_PLAN.md §3.2) - null/NONE for the vast
  // majority of the seeded catalog, which predates this feature and has no
  // verified measurements yet. The size-guide UI only renders when
  // measurementStatus is FLAMINGO_VERIFIED - see snippet_size_chart.dart.
  final String? fitType;
  final String? stretchLevel;
  final String measurementStatus;
  // Which body zone this product's category belongs to - UPPER/LOWER/FULL, or
  // null when the category has no fitZone set (e.g. sarees; size chart still
  // shows, comparison doesn't - SIZE_AND_FIT_PLAN.md §9 A1).
  final String? fitZone;
  // When the product was added to the catalog. Drives the "Newest/Oldest first"
  // sort in the filter sheet. Nullable because older cached payloads (and a few
  // endpoints) may omit it - those products sort as oldest.
  final DateTime? createdAt;
  // Ratings & reviews summary, nullable so endpoints that don't include it yet
  // just render no rating badge (see RatingBadgeWidget) instead of "0.0 (0)".
  final double? averageRating;
  final int? reviewCount;

  ProductDetail({
    required this.id,
    required this.title,
    required this.body,
    required this.status,
    required this.tags,
    required this.variants,
    required this.isInWishlist,
    required this.images,
    required this.stories,
    required this.seller,
    this.details,
    this.categoryName,
    this.fitType,
    this.stretchLevel,
    this.measurementStatus = 'NONE',
    this.fitZone,
    this.createdAt,
    this.averageRating,
    this.reviewCount,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        status: json['status'],
        details: json['details'],
        seller: Seller.fromJson(json['seller']),
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
        categoryName: json['productCategory'] == null ||
                List.from(json['productCategory']).isEmpty
            ? null
            : json['productCategory'][0]['category']['name'],
        fitType: json['fitType'],
        stretchLevel: json['stretchLevel'],
        measurementStatus: json['measurementStatus'] ?? 'NONE',
        fitZone: json['productCategory'] == null ||
                List.from(json['productCategory']).isEmpty
            ? null
            : json['productCategory'][0]['category']['fitZone'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.tryParse(json['createdAt'].toString()),
        averageRating: json['averageRating'] == null
            ? null
            : (json['averageRating'] as num).toDouble(),
        reviewCount: json['reviewCount'],
      );

  static List<ProductDetail> fromJsonList(dynamic json) =>
      List<ProductDetail>.from(
        json.map(
          (data) => ProductDetail.fromJson(data),
        ),
      );
}

class ProductVariant {
  final String id;
  final String sku;
  final int quantityInStock;
  final int price;
  final int effectivePrice;
  final int? originalPrice;
  final String productId;
  final ProductColor color;
  final ProductSizeOption size;
  final List<ProductAttributeResponse> attributes;
  final UploadFileResponse? image;
  final UploadFileResponse? secondaryImage;

  ProductVariant({
    required this.id,
    required this.sku,
    required this.quantityInStock,
    required this.price,
    required this.effectivePrice,
    required this.originalPrice,
    required this.productId,
    required this.color,
    required this.attributes,
    required this.image,
    this.secondaryImage,
    required this.size,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        id: json["id"],
        sku: json['sku'],
        quantityInStock: json['quantityInStock'],
        price: json['price'],
        effectivePrice: json['effectivePrice'] ?? json['price'],
        originalPrice: json['originalPrice'],
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
        secondaryImage: json['productVariantColor'][0]['secondaryImage'] == null
            ? null
            : UploadFileResponse.fromJson(
                json['productVariantColor'][0]['secondaryImage'],
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
