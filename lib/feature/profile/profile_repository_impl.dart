// ignore_for_file: unused_field

import 'package:flamingo/feature/profile/local/profile_local.dart';
import 'package:flamingo/feature/profile/model/profile.dart';
import 'package:flamingo/feature/profile/profile_repository.dart';

import 'package:flamingo/feature/profile/remote/profile_remote.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocal _profileLocal;
  final ProfileRemote _profileRemote;

  ProfileRepositoryImpl(
      {required ProfileLocal profileLocal,
      required ProfileRemote profileRemote})
      : _profileLocal = profileLocal,
        _profileRemote = profileRemote;

  @override
  Future<Profile> getProfile() async {
    return _profileRemote.getProfile();
  }

  @override
  String getProfileid() {
    return _profileRemote.getProfileid();
  }

  @override
  Future<List<Profile>> getbrandProfile() async {
    return _profileRemote.getbrandProfile();
  }
}
