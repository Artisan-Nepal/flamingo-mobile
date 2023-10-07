import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/dashboard/data/local/dashboard_local.dart';

class DashboardLocalImpl implements DashboardLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  DashboardLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
