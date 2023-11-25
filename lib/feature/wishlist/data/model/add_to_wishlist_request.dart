class UpdateWishlistRequest {
  final String productId;

  UpdateWishlistRequest({
    required this.productId,
  });

  Map<String, dynamic> toJson() => {
        "productId": productId,
      };
}
