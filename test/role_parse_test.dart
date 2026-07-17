import 'package:flutter_test/flutter_test.dart';
import 'package:flamingo/feature/user/data/customer.dart';
import 'package:flamingo/shared/enum/user_role.dart';

void main() {
  test('Customer.fromJson parses an admin-promoted account without throwing', () {
    final json = {
      "id": "94ab84ca",
      "firstName": null,
      "lastName": null,
      "roles": ["CUSTOMER", "ADMIN"],
      "createdAt": "2026-07-17T15:15:59.957Z",
      "email": "rojaneverest@gmail.com",
      "mobileNumber": null,
      "userId": "1fa64a13",
      "displayImageUrl": null,
      "sellerId": null
    };
    final c = Customer.fromJson(json);
    expect(c.roles.isCustomer, true);
    expect(c.roles.contains(UserRole.ADMIN), true);
  });

  test('unknown/future roles fall back to unknown instead of throwing', () {
    expect(userRoleFromString('SOME_FUTURE_ROLE'), UserRole.unknown);
  });
}
