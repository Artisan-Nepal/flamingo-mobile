class CreateAddressRequest {
  final String name;
  final String? landmark;
  final String areaId;

  CreateAddressRequest({
    required this.name,
    required this.areaId,
    this.landmark,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "landmark": landmark,
        "areaId": areaId,
      };
}
