import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/address/data/model/create_address_request.dart';
import 'package:flamingo/feature/address/data/model/customer_address.dart';
import 'package:flamingo/feature/address/data/model/sub_address.dart';
import 'package:flamingo/feature/address/data/model/update_address_request.dart';
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

  @override
  Future<List<CustomerAddress>> getCustomerAddresses() async {
    final apiResponse = await _apiClient.get(ApiUrls.customerAddress);
    return CustomerAddress.fromJsonList(apiResponse.data);
  }

  @override
  Future createAddress(CreateAddressRequest request) async {
    await _apiClient.post(ApiUrls.customerAddress, body: request.toJson());
  }

  @override
  Future updateAddress(String addressId, UpdateAddressRequest request) async {
    final url = '${ApiUrls.addresses}/$addressId';
    return await _apiClient.patch(url, body: request.toJson());
  }
}
