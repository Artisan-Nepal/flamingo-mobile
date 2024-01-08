class UpdateFavouriteVendorRequest {
  final String vendorId;

  UpdateFavouriteVendorRequest({
    required this.vendorId,
  });

  Map<String, dynamic> toJson() => {
        "vendorId": vendorId,
      };
}
