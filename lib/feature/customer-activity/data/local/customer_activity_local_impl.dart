import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/customer-activity/data/local/customer_activity_local.dart';

class CustomerActivityLocalImpl implements CustomerActivityLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  CustomerActivityLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
