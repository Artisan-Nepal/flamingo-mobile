import 'package:flamingo/data/remote/rest/api_client.dart';
import 'package:flamingo/feature/dashboard/data/remote/dashboard_remote.dart';

class DashbaordRemoteImpl implements DashboardRemote {
  // ignore: unused_field
  final ApiClient _apiClient;

  DashbaordRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;
}
