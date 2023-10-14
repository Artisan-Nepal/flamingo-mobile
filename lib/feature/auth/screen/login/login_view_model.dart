import 'package:flamingo/feature/auth/data/model/send_otp_response.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  LoginViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Response<SendOtpResponse> _sendOtpUseCase = Response<SendOtpResponse>();
  Response<LoginResponse> _verifyOtpUseCase = Response<LoginResponse>();
  bool _canResendCode = false;

  Response<SendOtpResponse> get sendOtpUseCase => _sendOtpUseCase;
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

  void setVerifyOtpUseCase(Response<LoginResponse> response) {
    _verifyOtpUseCase = response;
    notifyListeners();
  }

  Future<void> sendOtp(String mobileNumber) async {
    try {
      setSendOtpUseCase(Response.loading());
      final response = await _authRepository.sendLoginOtp(mobileNumber);
      _canResendCode = false;
      setSendOtpUseCase(Response.complete(response));
    } catch (exception) {
      setSendOtpUseCase(Response.error(exception));
    }
  }

  Future<void> resendOtp() async {
    try {
      final otpToken = _sendOtpUseCase.data!.otpToken;
      setSendOtpUseCase(Response.loading());
      final response = await _authRepository.resendLoginOtp(otpToken);
      _canResendCode = false;
      setSendOtpUseCase(Response.complete(response));
    } catch (exception) {
      setSendOtpUseCase(Response.error(exception));
    }
  }

  Future<void> verifyOtp(String otpCode) async {
    try {
      if (otpCode.length != CommonConstants.otpLength) {
        setVerifyOtpUseCase(Response.error("OTP must be of length 4"));
        return;
      }

      final otpToken = _sendOtpUseCase.data!.otpToken;
      setVerifyOtpUseCase(Response.loading());
      final response = await _authRepository.verifyLoginOtp(otpToken, otpCode);
      setVerifyOtpUseCase(Response.complete(response));
    } catch (exception) {
      setVerifyOtpUseCase(Response.error(exception));
    }
  }
}
