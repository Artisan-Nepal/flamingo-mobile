class UpdateAddressRequest {
  final String? name;
  final String? landmark;
  final String? areaId;

  UpdateAddressRequest({
    required this.name,
    required this.areaId,
    this.landmark,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (name != null) map['name'] = name;
    if (areaId != null) map['areaId'] = areaId;
    if (landmark != null) map['landmark'] = landmark;
    return map;
  }
}
