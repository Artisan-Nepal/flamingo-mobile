import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/feature/profile/profile_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class BrandProfileScreenmodel extends ChangeNotifier {
  final ProfileRepository _profileRepository;
  final ProductRepository _productRepository;

  BrandProfileScreenmodel({
    required ProfileRepository profileRepository,
    required ProductRepository productRepository,
  })  : _profileRepository = profileRepository,
        _productRepository = productRepository;

  Response<Profile> _profile = Response<Profile>();
  Response<Profile> get profile => _profile;
  Response<String> _id = Response<String>();
  Response<String> get id => _id;
  Response<List<Product>> _listofproduct = Response<List<Product>>();
  Response<List<Product>> get listofproduct => _listofproduct;

  Profile? userprofile;
  String? profile_id;
  List<Product> products = [];

  void setprofile(Response<Profile> response) {
    _profile = response;
    notifyListeners();
  }

  void setprofileid(Response<String> response) {
    _id = response;
    notifyListeners();
  }

  void setlistofproducts(Response<List<Product>> response) {
    _listofproduct = response;
    notifyListeners();
  }

  void getid() {
    setprofileid(Response.loading());
    final String id = _profileRepository.getProfileid();
    profile_id = id;
    print(id);
    setprofileid(Response.complete(id));
  }

  Future<void> getbrandproducts(String brand) async {
    setlistofproducts(Response.loading());
    final total_products = await _productRepository.getProductList();
    List<Product> brand_products = [];
    for (int i = 0; i < total_products.length; i++) {
      if (total_products[i].brand == brand) {
        brand_products.add(total_products[i]);
        print(total_products[i].name);
      }
    }
    products = brand_products;
    setlistofproducts(Response.complete(brand_products));
  }

  Future<void> getuserprofile() async {
    setprofile(Response.loading());
    final profile = await _profileRepository.getProfile();
    userprofile = profile;
    print(profile.name + " " + profile.address);
    setprofile(Response.complete(profile));
  }
}
