class LoginRequest {
  String username;
  String password;
  String apkVersion;
  String? firebaseToken;

  LoginRequest(
      {required this.username,
      required this.password,
      required this.apkVersion,
      this.firebaseToken});
}
