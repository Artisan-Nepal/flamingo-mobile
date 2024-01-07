import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/advertisement/data/local/advertisement_local.dart';

class AdvertisementLocalImpl implements AdvertisementLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  AdvertisementLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
