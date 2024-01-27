class CreateAddressRequest {
  final String name;
  final String? landmark;
  final String areaId;
  final String fullName;
  final String mobileNumber;

  CreateAddressRequest({
    required this.name,
    required this.areaId,
    required this.fullName,
    required this.mobileNumber,
    this.landmark,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "landmark": landmark,
        "areaId": areaId,
        "fullName": fullName,
        "mobileNumber": mobileNumber,
      };
}
