import 'package:flamingo/feature/product/data/model/product_detail.dart';

class VendorCollection {
  final String id;
  final String name;
  final String vendorId;
  final List<ProductDetail> products;
  final DateTime createdAt;

  VendorCollection({
    required this.id,
    required this.name,
    required this.vendorId,
    required this.products,
    required this.createdAt,
  });

  factory VendorCollection.fromJson(Map<String, dynamic> json) =>
      VendorCollection(
        id: json['id'],
        name: json['name'],
        vendorId: json['vendorId'],
        createdAt: DateTime.parse(json["createdAt"]),
        products: ProductDetail.fromJsonList(
            json['products'].map((e) => e['product'])),
      );

  static List<VendorCollection> fromJsonList(dynamic json) =>
      List<VendorCollection>.from(
        json.map(
          (data) => VendorCollection.fromJson(data),
        ),
      );
}

class VendorCollectionProduct {
  final String id;
  final String title;
  final String body;
  final String status;
  final List<String> images;
  final int price;

  VendorCollectionProduct({
    required this.id,
    required this.title,
    required this.body,
    required this.status,
    required this.images,
    required this.price,
  });

  factory VendorCollectionProduct.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'];
    return VendorCollectionProduct(
      id: productJson['id'],
      title: productJson['title'],
      body: productJson['body'],
      status: productJson['status'],
      price: productJson['variants'][0]['price'],
      images:
          List<String>.from(productJson['images'].map((i) => i['imageUrl'])),
    );
  }

  static List<VendorCollectionProduct> fromJsonList(dynamic json) =>
      List<VendorCollectionProduct>.from(
        json.map(
          (data) => VendorCollectionProduct.fromJson(data),
        ),
      );
}
