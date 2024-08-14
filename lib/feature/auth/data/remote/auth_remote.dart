import 'package:flamingo/feature/auth/data/model/logout_request.dart';
import 'package:flamingo/feature/auth/data/model/resend_otp_request.dart';
import 'package:flamingo/feature/auth/data/model/send_otp_response.dart';
import 'package:flamingo/feature/auth/data/model/verify_otp_request.dart';
import 'package:flamingo/feature/feature.dart';

abstract class AuthRemote {
  Future<SendOtpResponse> sendLoginOtp(SendOtpRequest request);
  Future<SendOtpResponse> resendLoginOtp(ResendOtpRequest request);
  Future<LoginResponse> verifyLoginOtp(VerifyOtpRequest request);
  Future<void> logout(LogoutRequest request);
}
