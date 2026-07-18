import 'package:flamingo/feature/address/data/address_repository.dart';
import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/address/data/model/create_address_request.dart';
import 'package:flamingo/feature/address/data/model/picked_location.dart';
import 'package:flamingo/feature/address/data/model/update_address_request.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class ManageAddressViewModel extends ChangeNotifier {
  final AddressRepository _addressRepository;

  ManageAddressViewModel({
    required AddressRepository addressRepository,
  }) : _addressRepository = addressRepository;

  Response _manageAddressUseCase = Response();
  Address? _existingAddress;
  PickedLocation? _pickedLocation;

  Response get manageAddressUseCase => _manageAddressUseCase;
  PickedLocation? get pickedLocation => _pickedLocation;

  // The location the address is (or will be) pinned to - the freshly picked one
  // if the user chose on the map this session, otherwise the existing address's
  // stored pin when editing.
  double? get latitude => _pickedLocation?.latitude ?? _existingAddress?.latitude;
  double? get longitude => _pickedLocation?.longitude ?? _existingAddress?.longitude;
  String? get formattedAddress => _pickedLocation?.formattedAddress ?? _existingAddress?.formattedAddress;
  bool get hasLocation => latitude != null && longitude != null;

  void init(Address? existingAddress) {
    _existingAddress = existingAddress;
    _pickedLocation = null;
    notifyListeners();
  }

  void setPickedLocation(PickedLocation location) {
    _pickedLocation = location;
    notifyListeners();
  }

  void setManageAddressUseCase(Response response) {
    _manageAddressUseCase = response;
    notifyListeners();
  }

  Future<void> manageAddress(
    String fullName,
    String mobileNumber,
    String address,
    String? landmark,
    String? existingAddressId,
  ) async {
    try {
      setManageAddressUseCase(Response.loading());
      if (existingAddressId == null) {
        await _addressRepository.createAddress(
          CreateAddressRequest(
            fullName: fullName,
            mobileNumber: mobileNumber,
            name: address,
            latitude: latitude!,
            longitude: longitude!,
            formattedAddress: formattedAddress,
            landmark: landmark,
          ),
        );
      } else {
        await _addressRepository.udpateAddress(
          existingAddressId,
          UpdateAddressRequest(
            name: address,
            latitude: latitude,
            longitude: longitude,
            formattedAddress: formattedAddress,
            landmark: landmark,
          ),
        );
      }
      setManageAddressUseCase(Response.complete(null));
    } catch (exception) {
      setManageAddressUseCase(Response.error(exception));
    }
  }
}
