class CustomerCountInfoResponse {
  int cartCount;
  int wishlistCount;
  int orderCount;

  CustomerCountInfoResponse({
    required this.cartCount,
    required this.wishlistCount,
    required this.orderCount,
  });

  factory CustomerCountInfoResponse.fromJson(Map<String, dynamic> json) {
    return CustomerCountInfoResponse(
      cartCount: json['cartCount'],
      wishlistCount: json['wishlistCount'],
      orderCount: json['orderCount'],
    );
  }
}
