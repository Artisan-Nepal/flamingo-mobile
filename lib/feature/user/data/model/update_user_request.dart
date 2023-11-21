class UpdateUserRequest {
  String? mobileNumber;
  String? email;
  String? firstName;
  String? lastName;

  UpdateUserRequest({
    this.mobileNumber,
    this.email,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {};

    if (mobileNumber != null) jsonMap['mobileNumber'] = mobileNumber;
    if (email != null) jsonMap['email'] = email;
    if (firstName != null) jsonMap['firstName'] = firstName;
    if (lastName != null) {
      jsonMap['lastName'] = lastName;
    }

    return jsonMap;
  }
}
