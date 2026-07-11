import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/order/data/local/order_local.dart';
import 'package:flamingo/feature/order/data/order_repository.dart';

// Safety net for a Khalti payment that completed but whose confirm call
// never reached the server (app killed mid-flow, network drop right after
// the WebView redirect, etc). Call opportunistically wherever the customer
// is likely to land after a checkout attempt - confirmKhaltiOrder is
// idempotent, so retrying a pidx that's already confirmed or genuinely dead
// is harmless.
class KhaltiReconciler {
  static Future<void> retryPendingConfirmIfAny() async {
    final orderLocal = locator<OrderLocal>();
    final pending = await orderLocal.getPendingKhaltiPidx();
    if (pending == null) return;

    final expiresAt = pending['expiresAt'] as DateTime;
    if (DateTime.now().isAfter(expiresAt)) {
      // Past its window - the server will have (or will lazily) restored
      // stock on its own; nothing left to retry.
      await orderLocal.clearPendingKhaltiPidx();
      return;
    }

    try {
      await locator<OrderRepository>().confirmKhaltiOrder(pending['pidx'] as String);
      await orderLocal.clearPendingKhaltiPidx();
    } catch (_) {
      // Still pending, or a genuine failure - leave it persisted and try
      // again next time this is called.
    }
  }
}
