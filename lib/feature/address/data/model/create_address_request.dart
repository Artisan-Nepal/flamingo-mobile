class CreateAddressRequest {
  final String name;
  final String? landmark;
  final String fullName;
  final String mobileNumber;
  final double latitude;
  final double longitude;
  final String? formattedAddress;

  CreateAddressRequest({
    required this.name,
    required this.fullName,
    required this.mobileNumber,
    required this.latitude,
    required this.longitude,
    this.formattedAddress,
    this.landmark,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "landmark": landmark,
        "fullName": fullName,
        "mobileNumber": mobileNumber,
        "latitude": latitude,
        "longitude": longitude,
        "formattedAddress": formattedAddress,
      };
}
