import 'package:flamingo/%20notification/notification.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/auth/data/model/send_otp_response.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/user/data/user_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  LoginViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Response<SendOtpResponse> _sendOtpUseCase = Response<SendOtpResponse>();
  Response<SendOtpResponse> _resendOtpUseCase = Response<SendOtpResponse>();
  Response<LoginResponse> _verifyOtpUseCase = Response<LoginResponse>();
  bool _canResendCode = false;
  String _otpToken = "";

  Response<SendOtpResponse> get sendOtpUseCase => _sendOtpUseCase;
  Response<SendOtpResponse> get resendOtpUseCase => _resendOtpUseCase;
  Response<LoginResponse> get verifyOtpUseCase => _verifyOtpUseCase;
  bool get canResendCode => _canResendCode;

  void allowResendCode() {
    _canResendCode = true;
    notifyListeners();
  }

  void setSendOtpUseCase(Response<SendOtpResponse> response) {
    _sendOtpUseCase = response;
    notifyListeners();
  }

  void setResendOtpUseCase(Response<SendOtpResponse> response) {
    _resendOtpUseCase = response;
    notifyListeners();
  }

  void setVerifyOtpUseCase(Response<LoginResponse> response) {
    _verifyOtpUseCase = response;
    notifyListeners();
  }

  Future<void> sendOtp(String email) async {
    try {
      setVerifyOtpUseCase(Response());
      setSendOtpUseCase(Response.loading());
      final response = await _authRepository.sendLoginOtp(email);
      _canResendCode = false;
      _otpToken = response.otpToken;
      setSendOtpUseCase(Response.complete(response));
    } catch (exception) {
      setSendOtpUseCase(Response.error(exception));
    }
  }

  Future<void> resendOtp() async {
    try {
      setVerifyOtpUseCase(Response());
      setResendOtpUseCase(Response.loading());
      final response = await _authRepository.resendLoginOtp(_otpToken);
      _canResendCode = false;
      _otpToken = response.otpToken;
      setResendOtpUseCase(Response.complete(response));
    } catch (exception) {
      setResendOtpUseCase(Response.error(exception));
    }
  }

  Future<void> verifyOtp(String otpCode) async {
    try {
      if (otpCode.length != CommonConstants.otpLength) {
        setVerifyOtpUseCase(
            Response.error(AppException("OTP must be of length 4")));
        return;
      }
      setVerifyOtpUseCase(Response.loading());
      final response = await _authRepository.verifyLoginOtp(_otpToken, otpCode);
      locator<AuthViewModel>().syncLocally();
      locator<CustomerActivityViewModel>().getCustomerCountInfo();
      locator<UserRepository>().createDevice(
          await locator<NotificationService>().getNotificationToken());

      setVerifyOtpUseCase(Response.complete(response));
    } catch (exception) {
      setVerifyOtpUseCase(Response.error(exception));
    }
  }

  Future<void> continueAsGuest() async {
    _authRepository.setGuestId('guest');
  }
}
