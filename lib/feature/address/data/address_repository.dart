import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/address/data/model/create_address_request.dart';
import 'package:flamingo/feature/address/data/model/sub_address.dart';
import 'package:flamingo/feature/address/data/model/update_address_request.dart';

abstract class AddressRepository {
  Future<FetchResponse<SubAddress>> getProvinces();
  Future<FetchResponse<City>> getCitiesByProvince(String provinceId);
  Future<FetchResponse<Area>> getAreasByCity(String cityId);
  Future<FetchResponse<Address>> getCustomerAddresses();
  Future createAddress(CreateAddressRequest request);
  Future udpateAddress(String addressId, UpdateAddressRequest request);
}
