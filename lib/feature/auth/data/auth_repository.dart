import 'package:flamingo/feature/auth/data/model/send_otp_response.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/user/data/customer.dart';

abstract class AuthRepository {
  Future<void> onBoard();
  Future<SendOtpResponse> sendLoginOtp(String email);
  Future<SendOtpResponse> resendLoginOtp(String otpToken);
  Future<LoginResponse> verifyLoginOtp(String otpToken, String otpCode);
  Future<void> setUserLocal(Customer user);
  Future<Customer?> getUserLocal();
  Future<bool> getIsLoggedIn();
  Future logout();
  Future<void> setGuestId(String value);
  Future removeGuestId();
  Future<String?> getGuestId();
}
