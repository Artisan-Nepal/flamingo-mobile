class VariantMeasurement {
  final String dimension;
  final int valueMm;
  final String geometry;

  VariantMeasurement({
    required this.dimension,
    required this.valueMm,
    required this.geometry,
  });

  factory VariantMeasurement.fromJson(Map<String, dynamic> json) =>
      VariantMeasurement(
        dimension: json['dimension'],
        valueMm: json['valueMm'],
        geometry: json['geometry'],
      );

  static List<VariantMeasurement> fromJsonList(dynamic json) =>
      List<VariantMeasurement>.from(
        json.map((data) => VariantMeasurement.fromJson(data)),
      );

  // Staff enter cm on the admin measurement-entry station; the API stores
  // integer mm (mirrors the money-in-paisa convention - SIZE_AND_FIT_PLAN.md
  // §2.8). Convert back to cm for display here, in one place.
  double get valueCm => valueMm / 10;
}

// Human labels and display order - mirrors flamingo-admin's
// DIMENSION_LABELS/UPPER_BODY_DIMENSIONS/LOWER_BODY_DIMENSIONS
// (src/interfaces/variantMeasurement.ts). Kept in sync by hand for now; no
// shared package between the two apps.
const Map<String, String> measurementDimensionLabels = {
  'CHEST': 'Chest',
  'SHOULDER': 'Shoulder',
  'BODY_LENGTH': 'Length',
  'SLEEVE_LENGTH': 'Sleeve',
  'BICEP': 'Bicep',
  'ARMHOLE': 'Armhole',
  'NECK': 'Neck',
  'HEM_WIDTH': 'Hem width',
  'WAIST': 'Waist',
  'HIP': 'Hip',
  'INSEAM': 'Inseam',
  'OUTSEAM': 'Outseam',
  'THIGH': 'Thigh',
  'RISE': 'Rise',
  'LEG_OPENING': 'Leg opening',
};

const List<String> measurementDimensionOrder = [
  'CHEST',
  'SHOULDER',
  'BODY_LENGTH',
  'SLEEVE_LENGTH',
  'BICEP',
  'ARMHOLE',
  'NECK',
  'HEM_WIDTH',
  'WAIST',
  'HIP',
  'INSEAM',
  'OUTSEAM',
  'THIGH',
  'RISE',
  'LEG_OPENING',
];
