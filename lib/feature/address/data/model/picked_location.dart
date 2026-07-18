/// The result returned by [LocationPickerScreen]: the exact pin the user
/// confirmed, plus the reverse-geocoded readable address (resolved once, on
/// Confirm).
class PickedLocation {
  final double latitude;
  final double longitude;
  final String formattedAddress;

  PickedLocation({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
  });
}
