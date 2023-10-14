class LoginResponse {
  final String accessToken;
  final UserResponse user;

  LoginResponse({
    required this.accessToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      user: UserResponse.fromJson(json['user']),
    );
  }
}

class UserResponse {
  final String id;
  final String mobileNumber;

  UserResponse({
    required this.id,
    required this.mobileNumber,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      mobileNumber: json['mobileNumber'],
    );
  }
}
