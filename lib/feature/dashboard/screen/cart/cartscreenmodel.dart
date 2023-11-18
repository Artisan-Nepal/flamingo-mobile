import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/feature/profile/profile_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class CartScreenmodel extends ChangeNotifier {
  final ProfileRepository _profileRepository;
  final ProductRepository _productRepository;

  CartScreenmodel({
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
  Response<List<Product>> _selecteditems = Response<List<Product>>();
  Response<List<Product>> get selecteditems => _selecteditems;
  // Response<List<bool>> _selectedorunselected = Response<List<bool>>();
  // Response<List<bool>> get selectedorunselected => _selectedorunselected;
  List<bool> sel = [];

  Profile? userprofile;
  String? profile_id;
  List<Product> products = [];
  List<Product> empty_selection = [];

  void setprofile(Response<Profile> response) {
    _profile = response;
    notifyListeners();
  }

  // void set_selectedorunselected(Response<List<bool>> response) {
  //   _selectedorunselected = response;
  //   notifyListeners();
  // }

  void setlistofproducts(Response<List<Product>> response) {
    _listofproducts = response;
    notifyListeners();
  }

  void setselecteditems(Response<List<Product>> response) {
    _selecteditems = response;
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

  Future<void> getcartlist() async {
    setlistofproducts(Response.loading());
    // set_selectedorunselected(Response.loading());
    Profile profile = await _profileRepository.getProfile();
    final total_products = await _productRepository.getProductList();

    List<Product> wishlist = []; //
    for (int i = 0; i < total_products.length; i++) {
      if (profile.wishlist.contains(total_products[i].id)) {
        wishlist.add(total_products[i]);
        sel.add(false);
      }
    }
    products = wishlist;
    setlistofproducts(Response.complete(wishlist));
    // set_selectedorunselected(Response.complete(sel));
  }

  ///changeable
  Future<void> removefromlist(int index) async {
    setselecteditems(Response.loading());
    setlistofproducts(Response.loading());
    // set_selectedorunselected(Response.loading());
    sel.removeAt(index);
    empty_selection.remove(products[index]);
    products.removeAt(index);

    print(products.toString());
    setlistofproducts(Response.complete(products));
    // set_selectedorunselected(Response.complete(sel));
    setselecteditems(Response.complete(empty_selection));
  }

  Future<void> itemselection(int index) async {
    setselecteditems(Response.loading());
    // set_selectedorunselected(Response.loading());
    empty_selection.add(products[index]);
    sel[index] = true;
    setselecteditems(Response.complete(empty_selection));
    // set_selectedorunselected(Response.complete(sel));
  }

  Future<void> itemremoval(int index) async {
    setselecteditems(Response.loading());
    // set_selectedorunselected(Response.loading());
    empty_selection.remove(products[index]);
    sel[index] = false;
    setselecteditems(Response.complete(empty_selection));
    // set_selectedorunselected(Response.complete(sel));
  }
}
