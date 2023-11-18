import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/feature/profile/profile_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddressScreenModel extends ChangeNotifier {
  final ProfileRepository _profileRepository;

  AddressScreenModel({
    required ProfileRepository profileRepository,
  }) : _profileRepository = profileRepository;

  Response<Profile> _profile = Response<Profile>();
  Response<Profile> get profile => _profile;
  Response<List<String>> _address = Response<List<String>>();
  Response<List<String>> get address => _address;
  Response<List<bool>> _address_selected = Response<List<bool>>();
  Response<List<bool>> get address_selected => _address_selected;

  void setprofile(Response<Profile> response) {
    _profile = response;
    notifyListeners();
  }

  void setaddressselected(Response<List<bool>> response) {
    _address_selected = response;
    notifyListeners();
  }

  // setlistofproducts(Response.loading());
  // job done
  // setlistofproducts(Response.complete(ListofProducts));

  Profile? userprofile;

  void setaddress(Response<List<String>> response) {
    _address = response;
    notifyListeners();
  }

  List<String>? profile_address;

  void getaddress() {
    setaddress(Response.loading());
    final List<String> address = _profileRepository.getaddress();
    profile_address = address;
    print(address);
    setaddress(Response.complete(address));
  }

  Future<void> getuserprofile() async {
    setprofile(Response.loading());

    final profile = await _profileRepository.getProfile();
    userprofile = profile;
    print(profile.name + " " + profile.address);
    setprofile(Response.complete(profile));
  }
}
