import 'package:flamingo/feature/user/data/model/seller_customer.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/shared/enum/seller_type.dart';

class Seller {
  final String id;
  final SellerType type;
  final SellerCustomer? customer;
  final Vendor? vendor;

  Seller({
    required this.id,
    required this.type,
    this.customer,
    this.vendor,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
      id: json["id"],
      type: sellerTypeFromString(json['type']),
      customer: json['customer'] == null
          ? null
          : SellerCustomer.fromJson(json['customer']),
      vendor: json['vendor'] == null ? null : Vendor.fromJson(json['vendor']));

  static List<Seller> fromJsonList(dynamic json) => List<Seller>.from(
        json.map(
          (data) => Seller.fromJson(data),
        ),
      );
  static List<Seller> fromFavouriteJsonList(dynamic json) => List<Seller>.from(
        json.map(
          (data) => Seller.fromJson(data['vendor']),
        ),
      );
}
