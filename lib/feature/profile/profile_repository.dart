import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/profile/model/profile.dart';

abstract class ProfileRepository {
  String getProfileid();
  Future<Profile> getProfile();
  Future<List<Profile>> getbrandProfile();
}
