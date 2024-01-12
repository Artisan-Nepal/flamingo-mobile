import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/advertisement/data/advertisement_repository.dart';
import 'package:flamingo/feature/advertisement/data/model/advertisement.dart';
import 'package:flamingo/feature/customer-activity/create_activity_view_model.dart';
import 'package:flamingo/shared/constant/advertisement_activity_type.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class AdvertisementListingViewModel extends ChangeNotifier {
  final AdvertisementRepository _advertisementRepository;

  AdvertisementListingViewModel({
    required AdvertisementRepository advertisementRepository,
  }) : _advertisementRepository = advertisementRepository;

  Response<FetchResponse<Advertisement>> _getAdvertisementsUseCase =
      Response<FetchResponse<Advertisement>>();

  Response<FetchResponse<Advertisement>> get getAdvertisementsUseCase =>
      _getAdvertisementsUseCase;

  void setAdvertisementsUseCase(
      Response<FetchResponse<Advertisement>> response) {
    _getAdvertisementsUseCase = response;
    notifyListeners();
  }

  Future<void> getAdvertisements() async {
    try {
      setAdvertisementsUseCase(Response.loading());
      final response = await _advertisementRepository.getAdvertisements();
      setAdvertisementsUseCase(Response.complete(response));

      for (Advertisement advertisement in response.rows) {
        await locator<CreateActivityViewModel>().createAdvertisementActivity(
          advertisementId: advertisement.id,
          activityType: AdvertisementActivityType.view,
        );
      }
    } catch (exception) {
      setAdvertisementsUseCase(Response.error(exception));
    }
  }
}
