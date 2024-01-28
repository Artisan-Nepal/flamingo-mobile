// ignore_for_file: unused_field

import 'package:flamingo/feature/advertisement/data/advertisement_repository.dart';
import 'package:flamingo/feature/advertisement/data/local/advertisement_local.dart';
import 'package:flamingo/feature/advertisement/data/model/advertisement.dart';
import 'package:flamingo/feature/advertisement/data/remote/advertisement_remote.dart';
import 'package:flamingo/feature/feature.dart';

class AdvertisementRepositoryImpl implements AdvertisementRepository {
  final AdvertisementLocal _advertisementLocal;
  final AdvertisementRemote _advertisementRemote;
  final AuthRepository _authRepository;

  AdvertisementRepositoryImpl({
    required AdvertisementLocal advertisementLocal,
    required AdvertisementRemote advertisementRemote,
    required AuthRepository authRepository,
  })  : _advertisementLocal = advertisementLocal,
        _advertisementRemote = advertisementRemote,
        _authRepository = authRepository;

  @override
  Future<List<Advertisement>> getAdvertisements() async {
    return await _advertisementRemote.getAdvertisements();
  }
}
