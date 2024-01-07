import 'package:flamingo/feature/advertisement/data/model/vendor_collection.dart';
import 'package:flamingo/feature/upload-file/data/model/upload_file_response.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';

class Advertisement {
  final String id;
  final String title;
  final String? description;
  final String vendorId;
  final Vendor vendor;
  final List<UploadFileResponse> images;
  final VendorCollection collection;
  final String primaryImageUrl;

  Advertisement({
    required this.id,
    required this.title,
    required this.description,
    required this.vendorId,
    required this.vendor,
    required this.images,
    required this.collection,
    required this.primaryImageUrl,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) => Advertisement(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        vendorId: json['vendorId'],
        primaryImageUrl: json['primaryImageUrl'],
        vendor: Vendor.fromJson(json['vendor']),
        images: UploadFileResponse.fromJsonList(
            json['advertisementImages'].map((e) => e['image'])),
        collection: VendorCollection.fromJson(json['vendorCollection']),
      );

  static List<Advertisement> fromJsonList(dynamic json) =>
      List<Advertisement>.from(
        json.map(
          (data) => Advertisement.fromJson(data),
        ),
      );
}
