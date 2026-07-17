// ignore_for_file: constant_identifier_names
// Mirrors the backend Role enum (ADMIN, CUSTOMER, LOCAL_VENDOR, BRAND_VENDOR).
// `unknown` is a catch-all so a role this app doesn't model (e.g. an admin who
// also has a CUSTOMER role, or a role added later) can't crash JSON parsing.
enum UserRole { CUSTOMER, ADMIN, LOCAL_VENDOR, BRAND_VENDOR, unknown }

UserRole userRoleFromString(String role) {
  return UserRole.values.firstWhere(
    (e) => e.toString() == 'UserRole.$role',
    orElse: () => UserRole.unknown,
  );
}

extension UserRoleGetters on List<UserRole> {
  bool get isCustomer => contains(UserRole.CUSTOMER);
}
