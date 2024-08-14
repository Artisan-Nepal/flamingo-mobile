import 'package:flamingo/data/remote/api_urls.dart';
import 'package:flamingo/feature/auth/data/model/logout_request.dart';
import 'package:flamingo/feature/auth/data/model/resend_otp_request.dart';
import 'package:flamingo/feature/auth/data/model/send_otp_response.dart';
import 'package:flamingo/feature/auth/data/model/verify_otp_request.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/data/remote/rest/api_client.dart';

class AuthRemoteImpl implements AuthRemote {
  final ApiClient _apiClient;

  AuthRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<SendOtpResponse> resendLoginOtp(ResendOtpRequest request) async {
    final apiResponse =
        await _apiClient.post(ApiUrls.resendLoginOtp, body: request.toJson());
    return SendOtpResponse.fromJson(apiResponse.data);
  }

  @override
  Future<SendOtpResponse> sendLoginOtp(SendOtpRequest request) async {
    final apiResponse =
        await _apiClient.post(ApiUrls.sendLoginOtp, body: request.toJson());
    return SendOtpResponse.fromJson(apiResponse.data);
  }

  @override
  Future<LoginResponse> verifyLoginOtp(VerifyOtpRequest request) async {
    final apiResponse =
        await _apiClient.post(ApiUrls.verifyLoginOtp, body: request.toJson());
    return LoginResponse.fromJson(apiResponse.data);
  }

  @override
  Future<void> logout(LogoutRequest request) async {
    await await _apiClient.post(ApiUrls.logout, body: request.toJson());
  }
}
