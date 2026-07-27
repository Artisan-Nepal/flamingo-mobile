// Information, never a verdict (SIZE_AND_FIT_PLAN.md §2.2, §9.3 in the
// business plan): this model carries a plain-language DIFFERENCE, not a fit
// prediction. There is deliberately no "fits"/"doesn't fit" field anywhere
// in this file.
class FitComparisonResult {
  final String referenceLabel;
  final String referenceZone;
  final List<FitComparisonItem> items;

  FitComparisonResult({
    required this.referenceLabel,
    required this.referenceZone,
    required this.items,
  });

  factory FitComparisonResult.fromJson(Map<String, dynamic> json) =>
      FitComparisonResult(
        referenceLabel: json['referenceLabel'],
        referenceZone: json['referenceZone'],
        items: json['items'] == null
            ? []
            : FitComparisonItem.fromJsonList(json['items']),
      );
}

class FitComparisonItem {
  final String dimension;
  final int deltaMm;
  final String direction; // LARGER | SMALLER
  final String descriptorKey;
  final String emphasis; // NONE | NOTABLE

  FitComparisonItem({
    required this.dimension,
    required this.deltaMm,
    required this.direction,
    required this.descriptorKey,
    required this.emphasis,
  });

  factory FitComparisonItem.fromJson(Map<String, dynamic> json) =>
      FitComparisonItem(
        dimension: json['dimension'],
        deltaMm: json['deltaMm'],
        direction: json['direction'],
        descriptorKey: json['descriptorKey'],
        emphasis: json['emphasis'],
      );

  static List<FitComparisonItem> fromJsonList(dynamic json) =>
      List<FitComparisonItem>.from(
        json.map((data) => FitComparisonItem.fromJson(data)),
      );

  double get absDeltaCm => (deltaMm / 10).abs();
  bool get isNotable => emphasis == 'NOTABLE';
}

// Maps the server's descriptorKey (SIZE_AND_FIT_PLAN.md §5 band seed) to
// display copy. Kept here, not on the server, so wording can be tuned per
// client without an API change - the server only sends the classification.
const Map<String, String> fitDescriptorLabels = {
  'about_the_same': 'about the same',
  'slightly_larger': 'slightly larger',
  'noticeably_larger': 'noticeably larger',
  'slightly_smaller': 'slightly smaller',
  'noticeably_smaller': 'noticeably smaller',
  'slightly_roomier': 'slightly roomier',
  'noticeably_roomier': 'noticeably roomier',
  'much_roomier': 'much roomier',
  'slightly_closer': 'slightly closer fitting',
  'noticeably_closer': 'noticeably closer fitting',
  'much_closer': 'much closer fitting',
  'slightly_longer': 'slightly longer',
  'noticeably_longer': 'noticeably longer',
  'much_longer': 'much longer',
  'slightly_shorter': 'slightly shorter',
  'noticeably_shorter': 'noticeably shorter',
  'much_shorter': 'much shorter',
};
