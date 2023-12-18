import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/address/data/model/create_address_request.dart';
import 'package:flamingo/feature/address/data/model/customer_address.dart';
import 'package:flamingo/feature/address/data/model/sub_address.dart';
import 'package:flamingo/feature/address/data/model/update_address_request.dart';

abstract class AddressRemote {
  Future<FetchResponse<SubAddress>> getProvinces();
  Future<FetchResponse<City>> getCitiesByProvince(String provinceId);
  Future<FetchResponse<Area>> getAreasByCity(String cityId);
  Future<List<CustomerAddress>> getCustomerAddresses();
  Future createAddress(CreateAddressRequest createAddressRequest);
  Future updateAddress(String addressId, UpdateAddressRequest request);
}
