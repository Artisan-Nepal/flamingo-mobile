import 'package:flamingo/feature/advertisement/data/model/advertisement.dart';

abstract class AdvertisementRemote {
  Future<List<Advertisement>> getAdvertisements();
}
