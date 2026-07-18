import 'package:flamingo/feature/address/data/model/sub_address.dart';

class Address {
  final String? fullName;
  final String? mobileNumber;
  final String id;
  final String name;
  final String? landmark;
  // Now nullable: addresses created via the map picker have coordinates but no
  // seeded Area (the backend made areaId optional). Legacy addresses may still
  // carry an area.
  final Area? area;
  final double? latitude;
  final double? longitude;
  final String? formattedAddress;

  Address({
    required this.id,
    required this.name,
    this.landmark,
    this.area,
    this.fullName,
    this.mobileNumber,
    this.latitude,
    this.longitude,
    this.formattedAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
      fullName: json['fullName'],
      mobileNumber: json['mobileNumber'],
      landmark: json['landmark'],
      area: json['area'] != null ? Area.fromJson(json['area']) : null,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      formattedAddress: json['formattedAddress'],
    );
  }

  // Human-readable location line: the map-picker's reverse-geocoded address,
  // falling back to the legacy area breadcrumb for older addresses.
  String get displayLocation => formattedAddress ?? area?.name ?? '';

  static List<Address> fromJsonList(dynamic json) => List<Address>.from(
        json.map(
          (data) => Address.fromJson(data),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "landmark": landmark,
        "fullName": fullName,
        "mobileNumber": mobileNumber,
        "area": area?.toJson(),
        "latitude": latitude,
        "longitude": longitude,
        "formattedAddress": formattedAddress,
      };
}
