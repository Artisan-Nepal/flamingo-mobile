import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/user/data/local/user_local.dart';

class UserLocalImpl implements UserLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  UserLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
