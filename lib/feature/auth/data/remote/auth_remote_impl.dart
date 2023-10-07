import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/data/remote/rest/api_client.dart';

class AuthRemoteImpl implements AuthRemote {
  // ignore: unused_field
  final ApiClient _apiClient;

  AuthRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<LoginResponse> login(
      String username, String password, String apkVersion) async {
    throw UnimplementedError();
  }
}
