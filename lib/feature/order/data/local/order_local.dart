abstract class OrderLocal {
  Future<void> savePendingKhaltiPidx(String pidx, DateTime expiresAt);
  Future<Map<String, dynamic>?> getPendingKhaltiPidx();
  Future<void> clearPendingKhaltiPidx();
}
