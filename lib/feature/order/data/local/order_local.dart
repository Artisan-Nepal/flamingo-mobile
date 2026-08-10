import 'package:flamingo/feature/order/data/model/last_checkout_selection.dart';

abstract class OrderLocal {
  Future<void> savePendingKhaltiPidx(String pidx, DateTime expiresAt);
  Future<Map<String, dynamic>?> getPendingKhaltiPidx();
  Future<void> clearPendingKhaltiPidx();

  Future<void> saveLastCheckoutSelection({
    required String shippingAddressId,
    required String billingAddressId,
    required String shippingMethodId,
  });
  Future<LastCheckoutSelection> getLastCheckoutSelection();
}
