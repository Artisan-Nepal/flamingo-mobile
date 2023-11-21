// ignore_for_file: constant_identifier_names
enum UserRole { CUSTOMER }

UserRole userRoleFromString(String role) {
  return UserRole.values.firstWhere((e) => e.toString() == 'UserRole.$role');
}

extension UserRoleGetters on List<UserRole> {
  bool get isCustomer => contains(UserRole.CUSTOMER);
}
