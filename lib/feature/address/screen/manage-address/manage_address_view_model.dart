import 'package:flamingo/feature/address/data/address_repository.dart';
import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/address/data/model/create_address_request.dart';
import 'package:flamingo/feature/address/data/model/sub_address.dart';
import 'package:flamingo/feature/address/data/model/update_address_request.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class ManageAddressViewModel extends ChangeNotifier {
  final AddressRepository _addressRepository;

  ManageAddressViewModel({
    required AddressRepository addressRepository,
  }) : _addressRepository = addressRepository;

  Response<List<SubAddress>> _provinceUseCase = Response<List<SubAddress>>();
  Response<List<City>> _cityUseCase = Response<List<City>>();
  Response<List<Area>> _areaUseCase = Response<List<Area>>();
  Response _manageAddressUseCase = Response();
  SubAddress? _selectedProvince;
  City? _selectedCity;
  Area? _selectedArea;
  Address? _existingAddress;

  Response<List<SubAddress>> get provinceUseCase => _provinceUseCase;
  Response<List<City>> get cityUseCase => _cityUseCase;
  Response<List<Area>> get areaUseCase => _areaUseCase;
  Response get manageAddressUseCase => _manageAddressUseCase;
  SubAddress? get selectedProvince => _selectedProvince;
  City? get selectedCity => _selectedCity;
  Area? get selectedArea => _selectedArea;

  init(Address? existingAddress) {
    _existingAddress = existingAddress;
    _selectedArea = _existingAddress?.area;
    _selectedCity = _selectedArea?.city;
    _selectedProvince = _selectedCity?.province;
    notifyListeners();
  }

  void setSelectedProvince(SubAddress province) {
    _selectedProvince = province;
    getCities();
    notifyListeners();
  }

  void setSelectedCity(City city) {
    _selectedCity = city;
    getAreas();
    notifyListeners();
  }

  void setSelectedArea(Area area) {
    _selectedArea = area;
    notifyListeners();
  }

  void setProvinceUseCase(Response<List<SubAddress>> response) {
    _provinceUseCase = response;
    notifyListeners();
  }

  void setCityUseCase(Response<List<City>> response) {
    _cityUseCase = response;
    notifyListeners();
  }

  void setAreaUseCase(Response<List<Area>> response) {
    _areaUseCase = response;
    notifyListeners();
  }

  void setManageAddressUseCase(Response response) {
    _manageAddressUseCase = response;
    notifyListeners();
  }

  Future<void> getProvinces() async {
    try {
      // _selectedProvince = null;
      // _selectedCity = null;
      // _selectedArea = null;
      setProvinceUseCase(Response.loading());
      final response = await _addressRepository.getProvinces();
      if (_selectedProvince != null) {
        getCities();
      }
      setProvinceUseCase(Response.complete(response.rows));
    } catch (exception) {
      setProvinceUseCase(Response.error(exception));
    }
  }

  Future<void> getCities() async {
    try {
      // _selectedCity = null;
      // _selectedArea = null;
      setCityUseCase(Response.loading());
      final response =
          await _addressRepository.getCitiesByProvince(selectedProvince!.id);
      if (_selectedCity != null) {
        getAreas();
      }
      setCityUseCase(Response.complete(response.rows));
    } catch (exception) {
      setCityUseCase(Response.error(exception));
    }
  }

  Future<void> getAreas() async {
    try {
      setAreaUseCase(Response.loading());
      final response =
          await _addressRepository.getAreasByCity(selectedCity!.id);
      // _selectedArea = null;
      setAreaUseCase(Response.complete(response.rows));
    } catch (exception) {
      setAreaUseCase(Response.error(exception));
    }
  }

  Future<void> manageAddress(
      String address, String? landmark, String? existingAddressId) async {
    try {
      setManageAddressUseCase(Response.loading());
      if (existingAddressId == null) {
        await _addressRepository.createAddress(CreateAddressRequest(
            name: address, areaId: _selectedArea!.id, landmark: landmark));
      } else {
        await _addressRepository.udpateAddress(
          existingAddressId,
          UpdateAddressRequest(
            name: address,
            areaId: _selectedArea!.id,
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
