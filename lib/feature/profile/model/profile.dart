import 'package:flamingo/feature/product/data/model/product.dart';

class Profile {
  final String address;
  final String coverPicture;
  final String bio;
  final String name;
  final String profileid;
  final String profilePicture;
  final List<String> wishlist;
  final List<String> cart;

  Profile({
    required this.bio,
    required this.profileid,
    required this.profilePicture,
    required this.coverPicture,
    required this.address,
    required this.name,
    required this.cart, //
    required this.wishlist, //test
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        cart: json['cart'], //
        wishlist: json['wishlist'], //
        profileid: json['profileid'],
        bio: json['bio'],
        profilePicture: json['imageurl'],
        coverPicture: json['coverimageurl'],
        name: json['name'],
        address: json['address']);
  }
}
