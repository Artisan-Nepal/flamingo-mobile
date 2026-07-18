// Shipping method codes, mirroring the backend's seeded ShippingMethod rows.
// STANDARD_SHIPPING is priced by the server's per-store distance-based quote
// (see PlaceOrderViewModel.fetchDeliveryQuote / LOCATION_PICKER_PLAN.md);
// the other methods use their own flat ShippingMethod.cost.
const String kStandardShippingCode = 'STANDARD_SHIPPING';
const String kClickAndCollectCode = 'CLICK_AND_COLLECT';
const String kSameDayDeliveryCode = 'SAME_DAY_DELIVERY';
