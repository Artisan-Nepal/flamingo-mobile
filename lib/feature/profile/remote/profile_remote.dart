import 'package:flamingo/feature/profile/model/profile.dart';

abstract class ProfileRemote {
  Future<Profile> getProfile();
  String getProfileid();
  Future<List<Profile>> getbrandProfile();
  List<String> getaddress();
}
