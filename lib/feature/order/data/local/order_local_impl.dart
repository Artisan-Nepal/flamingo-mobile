import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/order/data/local/order_local.dart';

class OrderLocalImpl implements OrderLocal {
  final LocalStorageClient _sharedPrefManager;

  OrderLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;

  @override
  Future<void> savePendingKhaltiPidx(String pidx, DateTime expiresAt) async {
    await _sharedPrefManager.setString(
        LocalStorageKeys.pendingKhaltiPidx, pidx);
    await _sharedPrefManager.setString(
        LocalStorageKeys.pendingKhaltiPidxExpiresAt,
        expiresAt.toIso8601String());
  }

  @override
  Future<Map<String, dynamic>?> getPendingKhaltiPidx() async {
    final pidx =
        await _sharedPrefManager.getString(LocalStorageKeys.pendingKhaltiPidx);
    final expiresAtRaw = await _sharedPrefManager
        .getString(LocalStorageKeys.pendingKhaltiPidxExpiresAt);
    if (pidx == null || expiresAtRaw == null) return null;
    return {'pidx': pidx, 'expiresAt': DateTime.parse(expiresAtRaw)};
  }

  @override
  Future<void> clearPendingKhaltiPidx() async {
    await _sharedPrefManager.remove(LocalStorageKeys.pendingKhaltiPidx);
    await _sharedPrefManager.remove(LocalStorageKeys.pendingKhaltiPidxExpiresAt);
  }
}
