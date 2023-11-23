import 'package:flamingo/feature/address/data/model/sub_address.dart';

class Address {
  final String id;
  final String name;
  final String? landmark;
  final Area area;

  Address({
    required this.id,
    required this.name,
    this.landmark,
    required this.area,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
      landmark: json['landmark'],
      area: Area.fromJson(json['area']),
    );
  }

  static List<Address> fromJsonList(dynamic json) => List<Address>.from(
        json.map(
          (data) => Address.fromJson(data),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "landmark": landmark,
        "area": area.toJson(),
      };
}
