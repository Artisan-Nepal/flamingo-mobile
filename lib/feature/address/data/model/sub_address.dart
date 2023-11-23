class SubAddress {
  final String id;
  final String name;

  SubAddress({
    required this.id,
    required this.name,
  });

  factory SubAddress.fromJson(Map<String, dynamic> json) {
    return SubAddress(
      id: json['id'],
      name: json['name'],
    );
  }

  static List<SubAddress> fromJsonList(dynamic json) => List<SubAddress>.from(
        json.map(
          (data) => SubAddress.fromJson(data),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class City extends SubAddress {
  final SubAddress province;

  City({
    required super.id,
    required super.name,
    required this.province,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      province: SubAddress.fromJson(json['province']),
    );
  }

  static List<City> fromJsonList(dynamic json) => List<City>.from(
        json.map(
          (data) => City.fromJson(data),
        ),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "province": province.toJson(),
      };
}

class Area extends SubAddress {
  final City city;

  Area({
    required super.id,
    required super.name,
    required this.city,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      name: json['name'],
      city: City.fromJson(json['city']),
    );
  }

  static List<Area> fromJsonList(dynamic json) => List<Area>.from(
        json.map(
          (data) => Area.fromJson(data),
        ),
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "city": city.toJson(),
      };
}
