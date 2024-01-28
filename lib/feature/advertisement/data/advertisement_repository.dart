import 'package:flamingo/feature/advertisement/data/model/advertisement.dart';

abstract class AdvertisementRepository {
  Future<List<Advertisement>> getAdvertisements();
}
