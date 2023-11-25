import 'package:flamingo/shared/shared.dart';

class Customer extends JsonSerializable {
  final List<UserRole> roles;
  final String id;
  final String mobileNumber;
  final String userId;
  final DateTime createdAt;
  final String? firstName;
  final String? lastName;
  final String? email;

  Customer({
    required this.roles,
    required this.id,
    required this.mobileNumber,
    required this.userId,
    required this.createdAt,
    this.firstName,
    this.lastName,
    this.email,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        roles: List<UserRole>.from(
            json['roles'].map((r) => userRoleFromString(r))),
        id: json["id"],
        mobileNumber: json["mobileNumber"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
      );

  @override
  Map<String, dynamic> toJson() => {
        "roles": List<String>.from(roles.map((x) => x.name)),
        "id": id,
        "mobileNumber": mobileNumber,
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
      };
}
