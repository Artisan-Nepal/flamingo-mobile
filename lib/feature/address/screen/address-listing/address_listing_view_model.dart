import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/address/data/address_repository.dart';
import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class AddressListingViewModel extends ChangeNotifier {
  final AddressRepository _addressRepository;

  AddressListingViewModel({required AddressRepository addressRepository})
      : _addressRepository = addressRepository;

  Response<FetchResponse<Address>> _getAddressesUseCase =
      Response<FetchResponse<Address>>();
  Response<FetchResponse<Address>> get getAddressesUseCase =>
      _getAddressesUseCase;

  void setAddressesUseCase(Response<FetchResponse<Address>> response) {
    _getAddressesUseCase = response;
    notifyListeners();
  }

  Future<void> getAddresses() async {
    try {
      setAddressesUseCase(Response.loading());
      final response = await _addressRepository.getCustomerAddresses();
      setAddressesUseCase(Response.complete(response));
    } catch (exception) {
      setAddressesUseCase(Response.error(exception));
    }
  }
}
