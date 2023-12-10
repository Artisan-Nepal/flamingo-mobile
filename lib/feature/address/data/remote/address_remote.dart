import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/address/data/model/sub_address.dart';

abstract class AddressRemote {
  Future<FetchResponse<SubAddress>> getProvinces();
  Future<FetchResponse<City>> getCitiesByProvince(String provinceId);
  Future<FetchResponse<Area>> getAreasByCity(String cityId);
  Future<FetchResponse<Address>> getCustomerAddresses();
}
