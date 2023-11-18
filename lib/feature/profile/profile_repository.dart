import 'package:flamingo/feature/profile/model/profile.dart';

abstract class ProfileRepository {
  String getProfileid();
  List<String> getaddress();
  Future<Profile> getProfile();
  Future<List<Profile>> getbrandProfile();
}
