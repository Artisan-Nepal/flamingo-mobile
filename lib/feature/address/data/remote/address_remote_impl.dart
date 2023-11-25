import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/address/data/model/sub_address.dart';
import 'package:flamingo/feature/address/data/remote/address_remote.dart';

class AddressRemoteImpl implements AddressRemote {
  final ApiClient _apiClient;

  AddressRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<FetchResponse<SubAddress>> getProvinces() async {
    final apiResponse = await _apiClient.get(ApiUrls.provinces);
    return FetchResponse.fromJson(
      apiResponse.data,
      SubAddress.fromJsonList,
    );
  }

  @override
  Future<FetchResponse<Area>> getAreasByCity(String cityId) async {
    final url = '${ApiUrls.areasByCity}/$cityId';
    final apiResponse = await _apiClient.get(url);
    return FetchResponse.fromJson(
      apiResponse.data,
      Area.fromJsonList,
    );
  }

  @override
  Future<FetchResponse<City>> getCitiesByProvince(String provinceId) async {
    final url = '${ApiUrls.citiesbyProvince}/$provinceId';
    final apiResponse = await _apiClient.get(url);
    return FetchResponse.fromJson(
      apiResponse.data,
      City.fromJsonList,
    );
  }
}
