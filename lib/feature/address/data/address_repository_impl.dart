// ignore_for_file: unused_field

import 'package:flamingo/data/data.dart';
import 'package:flamingo/data/model/fetch_response.dart';
import 'package:flamingo/feature/address/data/address_repository.dart';
import 'package:flamingo/feature/address/data/local/address_local.dart';
import 'package:flamingo/feature/address/data/model/create_address_request.dart';
import 'package:flamingo/feature/address/data/model/customer_address.dart';
import 'package:flamingo/feature/address/data/model/sub_address.dart';
import 'package:flamingo/feature/address/data/model/update_address_request.dart';
import 'package:flamingo/feature/address/data/remote/address_remote.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressLocal _addressLocal;
  final AddressRemote _addressRemote;

  AddressRepositoryImpl({
    required AddressLocal addressLocal,
    required AddressRemote addressRemote,
  })  : _addressLocal = addressLocal,
        _addressRemote = addressRemote;

  @override
  Future<FetchResponse<SubAddress>> getProvinces() async {
    return _addressRemote.getProvinces();
  }

  @override
  Future<FetchResponse<Area>> getAreasByCity(String cityId) async {
    return await _addressRemote.getAreasByCity(cityId);
  }

  @override
  Future<FetchResponse<City>> getCitiesByProvince(String provinceId) async {
    return await _addressRemote.getCitiesByProvince(provinceId);
  }

  @override
  Future<List<CustomerAddress>> getCustomerAddresses() async {
    return await _addressRemote.getCustomerAddresses();
  }

  @override
  Future createAddress(CreateAddressRequest createAddressRequest) async {
    return await _addressRemote.createAddress(createAddressRequest);
  }

  @override
  Future udpateAddress(String addressId, UpdateAddressRequest request) async {
    return await _addressRemote.updateAddress(addressId, request);
  }
}
