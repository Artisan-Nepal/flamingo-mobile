import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/upload-file/data/model/upload_file_response.dart';
import 'package:flamingo/shared/shared.dart';

class Vendor {
  final String id;
  final DateTime createdAt;
  final String? name;
  final String? legalName;
  final String storeName;
  final UploadFileResponse? registrationDocument;
  final String? registrationNumber;
  final String? description;
  final String? websiteUrl;
  final UploadFileResponse? displayImage;
  final UploadFileResponse? backgroundImage;
  final String? bankName;
  final String? bankAccName;
  final String? bankBranchName;
  final String? bankAccNumber;
  final String? pan;
  final VendorStatus status;
  final DateTime enrolledDate;
  final Address? businessAddress;
  final Address? warehouseAddress;
  final Address? returnAddress;
  final bool isFavourited;
  final String sellerId;

  Vendor({
    required this.id,
    required this.createdAt,
    required this.storeName,
    required this.status,
    required this.enrolledDate,
    this.name,
    this.legalName,
    this.description,
    this.registrationDocument,
    this.registrationNumber,
    this.websiteUrl,
    this.displayImage,
    this.backgroundImage,
    this.bankAccName,
    this.bankBranchName,
    this.bankName,
    this.pan,
    this.bankAccNumber,
    this.businessAddress,
    this.returnAddress,
    this.warehouseAddress,
    required this.isFavourited,
    required this.sellerId,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        storeName: json['storeName'],
        legalName: json['legalName'],
        name: json['name'],
        description: json['description'],
        websiteUrl: json['websiteUrl'],
        sellerId: json['sellerId'],
        displayImage: json['displayImage'] == null
            ? null
            : UploadFileResponse.fromJson(json['displayImage']),
        backgroundImage: json['backgroundImage'] == null
            ? null
            : UploadFileResponse.fromJson(json['backgroundImage']),
        bankAccName: json['bankAccName'],
        bankAccNumber: json['bankAccNumber'],
        bankBranchName: json['bankBranchName'],
        bankName: json['bankName'],
        pan: json['pan'],
        status: vendorStatusFromString(json['status']),
        enrolledDate: DateTime.parse(json['enrolledDate']),
        registrationNumber: json['registrationNumber'],
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
