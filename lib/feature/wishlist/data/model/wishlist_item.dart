class WishlistItem {
  final String id;

  WishlistItem({
    required this.id,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'],
    );
  }

  static List<WishlistItem> fromJsonList(dynamic json) =>
      List<WishlistItem>.from(
        json.map(
          (data) => WishlistItem.fromJson(data),
        ),
      );
}
