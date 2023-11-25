class AddToWishlistRequest {
  final String productId;

  AddToWishlistRequest({
    required this.productId,
  });

  Map<String, dynamic> toJson() => {
        "productId": productId,
      };
}
