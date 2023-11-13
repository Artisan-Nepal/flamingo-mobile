import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/feature/profile/profile_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class EditProfileModel extends ChangeNotifier {
  final ProfileRepository _profileRepository;

  EditProfileModel({
    required ProfileRepository profileRepository,
  }) : _profileRepository = profileRepository;

  Response<Profile> _profile = Response<Profile>();
  Response<Profile> get profile => _profile;
  Response<String> _id = Response<String>();
  Response<String> get id => _id;

  Profile? userprofile;
  String? profile_id;

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
}
