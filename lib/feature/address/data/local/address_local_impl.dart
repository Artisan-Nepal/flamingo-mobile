import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/address/data/local/address_local.dart';

class AddressLocalImpl implements AddressLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  AddressLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
