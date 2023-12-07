class UpdateCartRequest {
  final int quantity;

  UpdateCartRequest({
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
      };
}
