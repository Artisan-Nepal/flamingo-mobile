import 'package:flamingo/shared/enum/seller_type.dart';

class Seller {
  final String id;
  final String storeName;
  final String? displayImageUrl;
  final String? storeDescription;
  final String? bankName;
  final String? bankAccName;
  final String? bankAccNumber;
  final String? bankBranchName;
  final String? bankCheckPhoto;
  final String? pan;
  final SellerType type;

  Seller({
    required this.id,
    required this.type,
    required this.storeName,
    this.displayImageUrl,
    this.storeDescription,
    this.bankName,
    this.bankAccName,
    this.bankAccNumber,
    this.bankBranchName,
    this.bankCheckPhoto,
    this.pan,
  });

  bool get isVendor {
    return type.isVendor;
  }

  bool get isCustomer {
    return type.isCustomer;
  }

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["id"],
        type: sellerTypeFromString(json['type']),
        storeName: json['storeName'],
        bankAccName: json['bankAccName'],
        bankAccNumber: json['storeName'],
        bankBranchName: json['bankBranchName'],
        bankCheckPhoto: json['bankCheckPhoto'],
        bankName: json['bankName'],
        pan: json['pan'],
        displayImageUrl: json['displayImageUrl'],
        storeDescription: json['storeDescription'],
      );

  static List<Seller> fromJsonList(dynamic json) => List<Seller>.from(
        json.map(
          (data) => Seller.fromJson(data),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "storeName": storeName,
        "storeDescription": storeDescription,
        "displayImageUrl": displayImageUrl,
        "bankAccName": bankAccName,
        "bankBranchName": bankBranchName,
        "bankName": bankName,
        "pan": pan,
        "type": type.name
      };
}
