class PromoBanner {
  final String id;
  final String title;
  final String? subtitle;
  final String? couponId;
  final String? couponCode;
  // 'NONE' | 'SALE' - SALE means tapping opens the Sale listing.
  final String link;
  final bool requiresLogin;

  PromoBanner({
    required this.id,
    required this.title,
    required this.link,
    required this.requiresLogin,
    this.subtitle,
    this.couponId,
    this.couponCode,
  });

  bool get hasCoupon => couponId != null && couponCode != null;
  bool get linksToSale => link == 'SALE';

  factory PromoBanner.fromJson(Map<String, dynamic> json) => PromoBanner(
        id: json['id'],
        title: json['title'],
        subtitle: json['subtitle'],
        couponId: json['couponId'],
        couponCode: json['couponCode'],
        link: json['link'] ?? 'NONE',
        requiresLogin: json['requiresLogin'] ?? false,
      );

  static List<PromoBanner> fromJsonList(dynamic json) =>
      List<PromoBanner>.from(
        json.map((data) => PromoBanner.fromJson(data)),
      );
}
