import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/feature/profile/profile_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PaymentScreenModel extends ChangeNotifier {
  final ProfileRepository _profileRepository;

  PaymentScreenModel({
    required ProfileRepository profileRepository,
  }) : _profileRepository = profileRepository;

  Response<Profile> _profile = Response<Profile>();
  Response<Profile> get profile => _profile;
  Response<String> _selected_method = Response<String>();
  Response<String> get selected_method => _selected_method;

  void setprofile(Response<Profile> response) {
    _profile = response;
    notifyListeners();
  }

  void setselectedmethod(Response<String> response) {
    _selected_method = response;
    notifyListeners();
  }

  // setlistofproducts(Response.loading());
  // job done
  // setlistofproducts(Response.complete(ListofProducts));

  Profile? userprofile;

  Future<void> getuserprofile() async {
    setprofile(Response.loading());

    final profile = await _profileRepository.getProfile();
    userprofile = profile;
    print(profile.name + " " + profile.address);
    setprofile(Response.complete(profile));
  }

  void setselection(String selection) {
    setselectedmethod(Response.loading());
    final String select = selection;
    setselectedmethod(Response.complete(select));
  }
}
