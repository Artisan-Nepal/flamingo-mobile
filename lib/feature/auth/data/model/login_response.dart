import 'package:flamingo/feature/user/data/customer.dart';

class LoginResponse {
  final String accessToken;
  final String? refreshToken;
  final Customer user;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: Customer.fromJson(json['user']),
    );
  }
}
