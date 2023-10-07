class LoginResponse {
  final String token;

  final UserResponse user;

  LoginResponse(
    this.token,
    this.user,
  );
}

class UserResponse {
  final int id;

  final String fullName;

  final String email;

  final String phoneNumber;

  final String firstName;

  final String lastName;

  final String? refreshToken;

  UserResponse(
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.refreshToken,
  );
}
