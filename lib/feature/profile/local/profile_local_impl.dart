import 'package:flamingo/data/local/local.dart';

import 'package:flamingo/feature/profile/local/profile_local.dart';

class ProfileLocalImpl implements ProfileLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  ProfileLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
