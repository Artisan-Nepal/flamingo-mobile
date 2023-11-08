import 'package:flutter/material.dart';

class ProductColor {
  final String id;
  final String colorCode;
  final String name;
  final Color value;

  ProductColor({
    required this.id,
    required this.colorCode,
    required this.name,
    required this.value,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      id: json['id'],
      colorCode: json['colorCode'],
      name: json['name'],
      value: Color(
        int.parse('0xFF${json['colorCode']}'),
      ),
    );
  }
}
