import 'package:flamingo/feature/address/data/model/address.dart';

class CustomerAddress {
  final Address address;
  final String customerId;
  final String addressId;

  CustomerAddress({
    required this.address,
    required this.customerId,
    required this.addressId,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      customerId: json['customerId'],
      addressId: json['addressId'],
      address: Address.fromJson(json['address']),
    );
  }

  static List<CustomerAddress> fromJsonList(dynamic json) =>
      List<CustomerAddress>.from(
        json.map(
          (data) => CustomerAddress.fromJson(data),
        ),
      );
}
