import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/upload-file/data/model/upload_file_response.dart';
import 'package:flamingo/shared/enum/vendor_status.dart';
import 'package:flamingo/shared/shared.dart';

class Vendor extends JsonSerializable {
  final String id;
  final DateTime createdAt;
  final String? name;
  final String? legalName;
  final String storeName;
  final UploadFileResponse? registrationDocument;
  final String? registrationNumber;
  final String? description;
  final String? websiteUrl;
  final String? displayImageUrl;
  final String? backgroundImageUrl;
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
    this.displayImageUrl,
    this.backgroundImageUrl,
    this.bankAccName,
    this.bankBranchName,
    this.bankName,
    this.pan,
    this.bankAccNumber,
    this.businessAddress,
    this.returnAddress,
    this.warehouseAddress,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        storeName: json['storeName'],
        legalName: json['legalName'],
        name: json['name'],
        description: json['description'],
        websiteUrl: json['websiteUrl'],
        displayImageUrl: json['displayImageUrl'],
        backgroundImageUrl: json['backgroundImageUrl'],
        bankAccName: json['bankAccName'],
        bankAccNumber: json['bankAccNumber'],
        bankBranchName: json['bankBranchName'],
        bankName: json['bankName'],
        pan: json['pan'],
        status: vendorStatusFromString(json['status']),
        enrolledDate: DateTime.parse(json['enrolledDate']),
        registrationNumber: json['registrationNumber'],
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

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "storeName": storeName,
        "legalName": legalName,
        "name": name,
        "description": description,
        "websiteUrl": websiteUrl,
        "displayImageUrl": displayImageUrl,
        "backgroundImageUrl": backgroundImageUrl,
        "bankAccName": bankAccName,
        "bankBranchName": bankBranchName,
        "bankName": bankName,
        "pan": pan,
        "status": status.name,
        "enrolledDate": enrolledDate.toIso8601String(),
        "registrationDocument": registrationDocument?.toJson(),
        "registrationNumber": registrationNumber,
        "bankAccNumber": bankAccNumber,
        "businessAddress": businessAddress?.toJson(),
        "returnAddress": returnAddress?.toJson(),
        "warehouseAddress": warehouseAddress?.toJson(),
      };
}
