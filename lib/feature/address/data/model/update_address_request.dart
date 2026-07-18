class UpdateAddressRequest {
  final String? name;
  final String? landmark;
  final double? latitude;
  final double? longitude;
  final String? formattedAddress;

  UpdateAddressRequest({
    required this.name,
    this.landmark,
    this.latitude,
    this.longitude,
    this.formattedAddress,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (name != null) map['name'] = name;
    if (landmark != null) map['landmark'] = landmark;
    if (latitude != null) map['latitude'] = latitude;
    if (longitude != null) map['longitude'] = longitude;
    if (formattedAddress != null) map['formattedAddress'] = formattedAddress;
    return map;
  }
}
