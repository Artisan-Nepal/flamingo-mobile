import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/advertisement/data/model/advertisement.dart';
import 'package:flamingo/feature/advertisement/data/remote/advertisement_remote.dart';

class AdvertisementRemoteImpl implements AdvertisementRemote {
  final ApiClient _apiClient;

  AdvertisementRemoteImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<Advertisement>> getAdvertisements() async {
    final apiResponse = await _apiClient.get(ApiUrls.advertisements);
    return Advertisement.fromJsonList(apiResponse.data);
  }
}
