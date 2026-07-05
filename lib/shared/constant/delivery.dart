// Mirrors the backend delivery-charge rule (src/shared/constant/delivery.ts).
// Location-based charge applies to STANDARD_SHIPPING only; amounts are in paisa.
const int kDeliveryChargeStandard = 10000; // Rs 100 — Kathmandu inside ring road
const int kDeliveryChargeExtended = 15000; // Rs 150 — extended zones

const String kStandardShippingCode = 'STANDARD_SHIPPING';
const String kClickAndCollectCode = 'CLICK_AND_COLLECT';
const String kSameDayDeliveryCode = 'SAME_DAY_DELIVERY';

// Extended-charge zones (by delivery city name): Bhaktapur, Lalitpur (inside &
// outside ring road) and Kathmandu Outside Ring Road. Everywhere else is standard.
int getDeliveryChargeForCity(String? cityName) {
  final name = (cityName ?? '').toLowerCase();
  final isExtendedZone = name.contains('bhaktapur') ||
      name.contains('lalitpur') ||
      name.contains('kathmandu outside ring road');
  return isExtendedZone ? kDeliveryChargeExtended : kDeliveryChargeStandard;
}
