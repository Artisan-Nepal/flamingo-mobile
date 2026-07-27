// Mirrors flamingo-api's GarmentZone/FitTypeHint enums (SIZE_AND_FIT_PLAN.md
// §3.3). Kept as plain strings (not Dart enums) to match this app's existing
// pattern for server-driven enums (e.g. ProductStatus in product_detail.dart)
// - avoids a parse failure if the backend ever adds a value this app doesn't
// know about yet.
class FitReference {
  final String id;
  final String label;
  final String garmentZone; // UPPER | LOWER | FULL
  final String fitTypeHint; // SLIM | REGULAR | RELAXED | OVERSIZED | UNKNOWN
  final bool isDefaultForZone;
  final List<FitReferenceMeasurement> measurements;

  FitReference({
    required this.id,
    required this.label,
    required this.garmentZone,
    required this.fitTypeHint,
    required this.isDefaultForZone,
    required this.measurements,
  });

  factory FitReference.fromJson(Map<String, dynamic> json) => FitReference(
        id: json['id'],
        label: json['label'],
        garmentZone: json['garmentZone'],
        fitTypeHint: json['fitTypeHint'],
        isDefaultForZone: json['isDefaultForZone'] ?? false,
        measurements: json['measurements'] == null
            ? []
            : FitReferenceMeasurement.fromJsonList(json['measurements']),
      );

  static List<FitReference> fromJsonList(dynamic json) =>
      List<FitReference>.from(
        json.map((data) => FitReference.fromJson(data)),
      );
}

class FitReferenceMeasurement {
  final String dimension;
  final int valueMm;

  FitReferenceMeasurement({required this.dimension, required this.valueMm});

  factory FitReferenceMeasurement.fromJson(Map<String, dynamic> json) =>
      FitReferenceMeasurement(
        dimension: json['dimension'],
        valueMm: json['valueMm'],
      );

  static List<FitReferenceMeasurement> fromJsonList(dynamic json) =>
      List<FitReferenceMeasurement>.from(
        json.map((data) => FitReferenceMeasurement.fromJson(data)),
      );

  double get valueCm => valueMm / 10;

  // No `geometry` field sent - the API derives it from `dimension` server-side
  // (same reasoning as the admin measurement-entry station: this is always a
  // garment measured flat, never a body, so there's nothing to choose).
  Map<String, dynamic> toJson() => {'dimension': dimension, 'valueMm': valueMm};
}

const Map<String, String> garmentZoneLabels = {
  'UPPER': 'Top',
  'LOWER': 'Bottom',
  'FULL': 'Full body (dress/saree)',
};

const Map<String, String> fitTypeHintLabels = {
  'SLIM': 'Slim',
  'REGULAR': 'Regular',
  'RELAXED': 'Relaxed',
  'OVERSIZED': 'Oversized',
  'UNKNOWN': "Not sure",
};

// Which dimensions are offered for each zone when measuring a reference
// garment - mirrors flamingo-admin's UPPER/LOWER_BODY_DIMENSIONS
// (variantMeasurement.ts). FULL offers both, since a dress or saree can carry
// upper- and lower-body-relevant measurements at once.
const List<String> upperBodyReferenceDimensions = [
  'CHEST',
  'SHOULDER',
  'BODY_LENGTH',
  'SLEEVE_LENGTH',
];
const List<String> lowerBodyReferenceDimensions = [
  'WAIST',
  'HIP',
  'INSEAM',
];
