import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/upload-file/data/model/upload_file_response.dart';
import 'package:flamingo/feature/vendor/data/model/seller.dart';
import 'package:flamingo/shared/shared.dart';

class Vendor {
  final String id;
  final DateTime createdAt;
  final String? legalName;
  final UploadFileResponse? registrationDocument;
  final String? registrationNumber;
  final String? description;
  final String? websiteUrl;
  final UploadFileResponse? backgroundImage;
  final VendorStatus status;
  final DateTime enrolledDate;
  final Address? businessAddress;
  final Address? warehouseAddress;
  final Address? returnAddress;
  final bool isFavourited;
  final String sellerId;
  final Seller seller;

  Vendor({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.enrolledDate,
    this.legalName,
    this.description,
    this.registrationDocument,
    this.registrationNumber,
    this.websiteUrl,
    this.backgroundImage,
    this.businessAddress,
    this.returnAddress,
    this.warehouseAddress,
    required this.isFavourited,
    required this.sellerId,
    required this.seller,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        legalName: json['legalName'],
        description: json['description'],
        websiteUrl: json['websiteUrl'],
        sellerId: json['sellerId'],
        backgroundImage: json['backgroundImage'] == null
            ? null
            : UploadFileResponse.fromJson(json['backgroundImage']),
        status: vendorStatusFromString(json['status']),
        enrolledDate: DateTime.parse(json['enrolledDate']),
        registrationNumber: json['registrationNumber'],
        seller: Seller.fromJson(json['seller']),
        isFavourited: json['customerFavourites'] == null
            ? false
            : List.from(json['customerFavourites']).isNotEmpty,
        registrationDocument: json['registrationDocument'] == null
            ? null
            : UploadFileResponse.fromJson(json['registrationDocument']),
        businessAddress: json['businessAddress'] == null
            ? null
            : Address.fromJson(
                json['businessAddress'],
              ),
        returnAddress: json['returnAddress'] == null
            ? null
            : Address.fromJson(
                json['returnAddress'],
              ),
        warehouseAddress: json['warehouseAddress'] == null
            ? null
            : Address.fromJson(
                json['warehouseAddress'],
              ),
      );

  static List<Vendor> fromJsonList(dynamic json) => List<Vendor>.from(
        json.map(
          (data) => Vendor.fromJson(data),
        ),
      );
  static List<Vendor> fromFavouriteJsonList(dynamic json) => List<Vendor>.from(
        json.map(
          (data) => Vendor.fromJson(data['vendor']),
        ),
      );
}
