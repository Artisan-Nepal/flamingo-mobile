import 'package:flamingo/feature/user/data/customer.dart';

class LoginResponse {
  final String accessToken;
  final Customer user;

  LoginResponse({
    required this.accessToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      user: Customer.fromJson(json['user']),
    );
  }
}
