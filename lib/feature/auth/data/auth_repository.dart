import 'package:flamingo/feature/auth/data/model/send_otp_response.dart';
import 'package:flamingo/feature/feature.dart';

abstract class AuthRepository {
  Future<void> onBoard();
  Future<SendOtpResponse> sendLoginOtp(String mobileNumber);
  Future<SendOtpResponse> resendLoginOtp(String otpToken);
  Future<LoginResponse> verifyLoginOtp(String otpToken, String otpCode);
}
