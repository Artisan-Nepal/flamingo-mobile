class CreateAdvertisementRequest {
  final String title;
  final String description;
  final List<String> advertisementImages;
  final String vendorCollectionId;

  CreateAdvertisementRequest({
    required this.title,
    required this.description,
    required this.advertisementImages,
    required this.vendorCollectionId,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "advertisementImages": advertisementImages,
        "vendorCollectionId": vendorCollectionId,
      };
}
