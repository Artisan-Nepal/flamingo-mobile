// ignore_for_file: unused_field

import 'package:flamingo/feature/dashboard/data/dashboard_repository.dart';
import 'package:flamingo/feature/dashboard/data/local/dashboard_local.dart';
import 'package:flamingo/feature/dashboard/data/remote/dashboard_remote.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocal _authLocal;
  final DashboardRemote _authRemote;

  DashboardRepositoryImpl(
      {required DashboardLocal authLocal, required DashboardRemote authRemote})
      : _authLocal = authLocal,
        _authRemote = authRemote;
}
