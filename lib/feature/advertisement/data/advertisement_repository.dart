import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/advertisement/data/model/advertisement.dart';

abstract class AdvertisementRepository {
  Future<FetchResponse<Advertisement>> getAdvertisements();
}