class RegisterSellerRequest {
  final String storeName;
  final String storeDescription;

  RegisterSellerRequest({
    required this.storeDescription,
    required this.storeName,
  });

  Map<String, dynamic> toJson() => {
        "storeName": storeName,
        "storeDescription": storeDescription,
      };
}
