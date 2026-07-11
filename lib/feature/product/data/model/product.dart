import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/shared/util/custom_functions.dart';

class Product {
  final String productId;
  final String title;
  final String image;
  final int quantity;
  // Price the customer pays (after any active discount) - what the card shows
  // as the main price.
  final int price;
  // The pre-discount list price when a discount is active, else null. When set,
  // the card renders it struck through next to `price`.
  final int? originalPrice;
  final String sellerStoreName;
  final String? sellerId;
  final ProductDetail? product;

  Product({
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    required this.image,
    required this.sellerStoreName,
    this.originalPrice,
    this.sellerId,
    this.product,
  });

  bool get isDiscounted => originalPrice != null && originalPrice! > price;

  int? get discountPercent =>
      isDiscounted ? (100 * (originalPrice! - price) / originalPrice!).round() : null;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      title: json['title'],
      image: json['imageUrl'],
      quantity: json['quantity'],
      price: json['price'],
      sellerStoreName: json['sellerStoreName'],
      sellerId: json['sellerId'],
    );
  }

  // Builds a listing card from a full ProductDetail. Picks the display variant
  // as the first one currently on discount (originalPrice set) so a card in the
  // Sale grid always shows the sale price, else the first variant. `price` is
  // the discounted (effective) price; `originalPrice` drives the strikethrough.
  factory Product.fromDetail(ProductDetail product) {
    final variants = product.variants;
    final displayVariant = variants.firstWhere(
      (v) => v.originalPrice != null,
      orElse: () => variants.first,
    );
    return Product(
      productId: product.id,
      title: product.title,
      image: extractProductDefaultImage(product.images, variants),
      quantity: displayVariant.quantityInStock,
      price: displayVariant.effectivePrice,
      originalPrice: displayVariant.originalPrice,
      sellerStoreName: product.seller.storeName,
      sellerId: product.seller.id,
      product: product,
    );
  }

  static List<Product> fromJsonList(dynamic json) => List<Product>.from(
        json.map(
          (data) => Product.fromJson(data),
        ),
      );
}
