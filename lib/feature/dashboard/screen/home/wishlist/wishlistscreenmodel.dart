import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/feature/profile/profile_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class WishlistScreenModel extends ChangeNotifier {
  final ProfileRepository _profileRepository;
  final ProductRepository _productRepository;

  WishlistScreenModel({
    required ProfileRepository profileRepository,
    required ProductRepository productRepository,
  })  : _profileRepository = profileRepository,
        _productRepository = productRepository;

  Response<Profile> _profile = Response<Profile>();
  Response<Profile> get profile => _profile;
  Response<String> _id = Response<String>();
  Response<String> get id => _id;
  Response<List<Product>> _listofproducts = Response<List<Product>>();
  Response<List<Product>> get listofproducts => _listofproducts;

  Profile? userprofile;
  String? profile_id;
  List<Product> products = [];

  void setprofile(Response<Profile> response) {
    _profile = response;
    notifyListeners();
  }

  void setlistofproducts(Response<List<Product>> response) {
    _listofproducts = response;
    notifyListeners();
  }

  void setprofileid(Response<String> response) {
    _id = response;
    notifyListeners();
  }

  void getid() {
    setprofileid(Response.loading());
    final String id = _profileRepository.getProfileid();
    profile_id = id;
    print(id);
    setprofileid(Response.complete(id));
  }

  Future<void> getuserprofile() async {
    setprofile(Response.loading());
    final profile = await _profileRepository.getProfile();
    userprofile = profile;
    print(profile.name + " " + profile.address);
    setprofile(Response.complete(profile));
  }

  Future<void> getWishlist() async {
    setlistofproducts(Response.loading());
    Profile profile = await _profileRepository.getProfile();
    final total_products = await _productRepository.getProductList();
    List<Product> wishlist = [];
    for (int i = 0; i < total_products.length; i++) {
      if (profile.wishlist.contains(total_products[i].id)) {
        wishlist.add(total_products[i]);
      }
    }
    products = wishlist;
    setlistofproducts(Response.complete(wishlist));
  }

  ///changeable
  Future<void> removefromlist(int index) async {
    setlistofproducts(Response.loading());

    products.removeAt(index);
    print(products.toString());
    setlistofproducts(Response.complete(products));
  }
}
