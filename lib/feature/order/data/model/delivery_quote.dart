class DeliveryQuoteStore {
  final String sellerId;
  final String? storeName;
  final int fee;

  DeliveryQuoteStore({
    required this.sellerId,
    required this.storeName,
    required this.fee,
  });

  factory DeliveryQuoteStore.fromJson(Map<String, dynamic> json) {
    return DeliveryQuoteStore(
      sellerId: json['sellerId'],
      storeName: json['storeName'],
      fee: json['fee'],
    );
  }
}

/// The real, server-computed delivery total for the current cart + address +
/// shipping method - the per-store distance-based fees, summed. See
/// This replaces the old client-side city guess.
class DeliveryQuote {
  final int totalDeliveryCharge;
  final int storeCount;
  final List<DeliveryQuoteStore> chargeByStore;

  DeliveryQuote({
    required this.totalDeliveryCharge,
    required this.storeCount,
    required this.chargeByStore,
  });

  factory DeliveryQuote.fromJson(Map<String, dynamic> json) {
    return DeliveryQuote(
      totalDeliveryCharge: json['totalDeliveryCharge'],
      storeCount: json['storeCount'],
      chargeByStore: (json['chargeByStore'] as List)
          .map((e) => DeliveryQuoteStore.fromJson(e))
          .toList(),
    );
  }
}
