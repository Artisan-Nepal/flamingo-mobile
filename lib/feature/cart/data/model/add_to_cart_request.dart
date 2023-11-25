class AddToCartRequest {
  final String productVariantId;
  final int quantity;

  AddToCartRequest({
    required this.productVariantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        "productVariantId": productVariantId,
        "quantity": quantity,
      };
}
