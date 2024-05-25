import 'package:flamingo/feature/customer-activity/data/customer_activity_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class CreateActivityViewModel extends ChangeNotifier {
  final CustomerActivityRepository _customerActivityRepository;

  CreateActivityViewModel(
      {required CustomerActivityRepository customerActivityRepository})
      : _customerActivityRepository = customerActivityRepository;

  Response _createUserActivityUseCase = Response();
  Response _createAdvertisementUseCase = Response();

  Response get createUserActivityUseCase => _createUserActivityUseCase;
  Response get createAdvertisementUseCase => _createAdvertisementUseCase;

  void setUserActivityUseCase(Response response) {
    _createUserActivityUseCase = response;
    notifyListeners();
  }

  void setAdvertisementActivityUseCase(Response response) {
    _createAdvertisementUseCase = response;
    notifyListeners();
  }

  Future<void> createUserActivity({
    String? sellerId,
    String? productId,
    required String activityType,
  }) async {
    try {
      setUserActivityUseCase(Response.loading());
      await _customerActivityRepository.createUserActivity(
        sellerId: sellerId,
        productId: productId,
        activityType: activityType,
      );
      setUserActivityUseCase(Response.complete(null));
    } catch (exception) {
      setUserActivityUseCase(Response.error(exception));
    }
  }

  Future<void> createAdvertisementActivity({
    required String advertisementId,
    String? productId,
    required String activityType,
  }) async {
    try {
      setAdvertisementActivityUseCase(Response.loading());
      await _customerActivityRepository.createAdvertisementActivity(
        advertisementId: advertisementId,
        productId: productId,
        activityType: activityType,
      );
      setAdvertisementActivityUseCase(Response.complete(null));
    } catch (exception) {
      setAdvertisementActivityUseCase(Response.error(exception));
    }
  }
}
