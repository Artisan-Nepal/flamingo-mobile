import 'package:flamingo/feature/auth/data/model/resend_otp_request.dart';
import 'package:flamingo/feature/auth/data/model/send_otp_response.dart';
import 'package:flamingo/feature/auth/data/model/verify_otp_request.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/user/data/customer.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocal _authLocal;
  final AuthRemote _authRemote;

  AuthRepositoryImpl(
      {required AuthLocal authLocal, required AuthRemote authRemote})
      : _authLocal = authLocal,
        _authRemote = authRemote;

  @override
  Future<void> onBoard() async {
    await _authLocal.setIsFirstTime(false);
  }

  @override
  Future<SendOtpResponse> sendLoginOtp(String mobileNumber) async {
    return await _authRemote
        .sendLoginOtp(SendOtpRequest(mobileNumber: mobileNumber));
  }

  @override
  Future<SendOtpResponse> resendLoginOtp(String otpToken) async {
    return await _authRemote
        .resendLoginOtp(ResendOtpRequest(otpToken: otpToken));
  }

  @override
  Future<LoginResponse> verifyLoginOtp(String otpToken, String otpCode) async {
    final request = VerifyOtpRequest(otpCode: otpCode, otpToken: otpToken);
    final apiResponse = await _authRemote.verifyLoginOtp(request);

    await _authLocal.setAccessToken(apiResponse.accessToken);
    await _authLocal.setUser(apiResponse.user);

    return apiResponse;
  }

  @override
  Future<bool> getIsLoggedIn() async {
    return (await _authLocal.getAccessToken()) != null;
  }

  @override
  Future<Customer?> getUserLocal() async {
    return await _authLocal.getUser();
  }

  @override
  Future<void> setUserLocal(Customer user) async {
    return await _authLocal.setUser(user);
  }
}
