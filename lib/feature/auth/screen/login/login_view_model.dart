import 'package:flamingo/feature/auth/data/model/send_otp_response.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  LoginViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Response<SendOtpResponse> _sendOtpUseCase = Response<SendOtpResponse>();
  Response<SendOtpResponse> _resendOtpUseCase = Response<SendOtpResponse>();
  Response<LoginResponse> _verifyOtpUseCase = Response<LoginResponse>();

  Response<SendOtpResponse> get sendOtpUseCase => _sendOtpUseCase;
  Response<SendOtpResponse> get resendOtpUseCase => _resendOtpUseCase;
  Response<LoginResponse> get verifyOtpUseCase => _verifyOtpUseCase;

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

  Future<void> sendOtp(String mobileNumber) async {
    try {
      setSendOtpUseCase(Response.loading());
      final response = await _authRepository.sendLoginOtp(mobileNumber);
      setSendOtpUseCase(Response.complete(response));
    } catch (exception) {
      setSendOtpUseCase(Response.error(exception));
    }
  }

  Future<void> resendOtp(String otpToken) async {
    try {
      setResendOtpUseCase(Response.loading());
      final response = await _authRepository.resendLoginOtp(otpToken);
      setResendOtpUseCase(Response.complete(response));
    } catch (exception) {
      setResendOtpUseCase(Response.error(exception));
    }
  }

  Future<void> verifyOtp(String otpToken, String otpCode) async {
    try {
      setVerifyOtpUseCase(Response.loading());
      final response = await _authRepository.verifyLoginOtp(otpToken, otpCode);
      setVerifyOtpUseCase(Response.complete(response));
    } catch (exception) {
      setVerifyOtpUseCase(Response.error(exception));
    }
  }
}
