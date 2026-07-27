// "Closest to your reference: L" - SIZE_AND_FIT_PLAN.md §9/B1. A similarity
// ranking across this product's own sizes, never a fit prediction - there is
// deliberately no "will fit"/confidence field here, matching
// fit_comparison.dart's same policy boundary (§2.2/§9.3).
class SuggestedSizeResult {
  final String? suggestedVariantId;
  final String? suggestedSizeLabel;
  final int? sharedDimensionCount;
  final String? reason;

  SuggestedSizeResult({
    this.suggestedVariantId,
    this.suggestedSizeLabel,
    this.sharedDimensionCount,
    this.reason,
  });

  bool get hasSuggestion => suggestedSizeLabel != null;

  factory SuggestedSizeResult.fromJson(Map<String, dynamic> json) =>
      SuggestedSizeResult(
        suggestedVariantId: json['suggestedVariantId'],
        suggestedSizeLabel: json['suggestedSizeLabel'],
        sharedDimensionCount: json['sharedDimensionCount'],
        reason: json['reason'],
      );
}
