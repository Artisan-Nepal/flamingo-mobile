import 'package:flamingo/feature/address/data/address_repository.dart';
import 'package:flamingo/feature/address/data/model/customer_address.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class AddressListingViewModel extends ChangeNotifier {
  final AddressRepository _addressRepository;

  AddressListingViewModel({required AddressRepository addressRepository})
      : _addressRepository = addressRepository;

  Response<List<CustomerAddress>> _getAddressesUseCase =
      Response<List<CustomerAddress>>();
  Response<List<CustomerAddress>> get getAddressesUseCase =>
      _getAddressesUseCase;

  void setAddressesUseCase(Response<List<CustomerAddress>> response) {
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
