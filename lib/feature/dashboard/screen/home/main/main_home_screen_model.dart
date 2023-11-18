import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/feature/profile/profile_repository.dart';
import 'package:flamingo/shared/shared.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MainHometScreenModel extends ChangeNotifier {
  final ProductRepository _productRepository;
  final ProfileRepository _profileRepository;

  MainHometScreenModel({
    required ProductRepository productRepository,
    required ProfileRepository profileRepository,
  })  : _productRepository = productRepository,
        _profileRepository = profileRepository;
  List<Product> _products = [];
  List<Product> _wishlistproducts = [];
  Response<List<Product>> _listofproducts = Response<List<Product>>();
  Response<List<Product>> get listofproducts => _listofproducts;
  Response<Profile> _profile = Response<Profile>();
  Response<Profile> get profile => _profile;
  Response<String> _id = Response<String>();
  Response<String> get id => _id;
  Response<List<Product>> _wishlist = Response<List<Product>>();
  Response<List<Product>> get wishlist => _wishlist;

  Profile? userprofile;
  String? profile_id;

  void setwishlist(Response<List<Product>> response) {
    _wishlist = response;
    notifyListeners();
  }
  // Response<List<Product>> _listofproducts = Response<List<Product>>();
  // Response<List<Product>> get listofproducts => _listofproducts;
  // void setlistofproducts(Response<List<Product>> response) {
  //   _listofproducts = response;
  //   notifyListeners();
  // }
  // setlistofproducts(Response.loading());
  // job done
  // setlistofproducts(Response.complete(ListofProducts));

  void setlistofproducts(Response<List<Product>> response) {
    _listofproducts = response;
    notifyListeners();
  }

  void setprofile(Response<Profile> response) {
    _profile = response;
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

  Future<void> getlistofproducts() async {
    setlistofproducts(Response.loading());
    final List<Product> ListofProducts =
        await _productRepository.getProductList();
    _products = ListofProducts;
    print(_products.length);
    setlistofproducts(Response.complete(ListofProducts));
  }

  Future<void> getWishlist() async {
    setwishlist(Response.loading());
    Profile profile = await _profileRepository.getProfile();
    final total_products = await _productRepository.getProductList();
    List<Product> wishlists = [];
    for (int i = 0; i < total_products.length; i++) {
      if (profile.wishlist.contains(total_products[i].id)) {
        wishlists.add(total_products[i]);
      }
    }
    _wishlistproducts = wishlists;
    setwishlist(Response.complete(wishlists));
  }

  ///changeable
  Future<void> removefromlist(int index) async {
    setwishlist(Response.loading());

    _wishlistproducts.removeAt(index);
    print(_wishlistproducts);
    setwishlist(Response.complete(_wishlistproducts));
  }
}
