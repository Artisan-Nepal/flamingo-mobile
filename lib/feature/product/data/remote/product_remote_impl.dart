import 'package:flamingo/data/remote/rest/api_client.dart';
import 'package:flamingo/feature/product/data/model/product_color.dart';
import 'package:flamingo/feature/product/data/remote/product_remote.dart';
import 'package:flutter/material.dart';

class ProductRemoteImpl implements ProductRemote {
  // ignore: unused_field
  final ApiClient _apiClient;

  ProductRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<ProductColor>> getProductColors() async {
    return [
      ProductColor(
        id: '1',
        colorCode: '000000',
        name: 'Black',
        value: Colors.black,
      ),
      ProductColor(
        id: '2',
        colorCode: 'FFFFFF',
        name: 'White',
        value: Colors.white,
      ),
      ProductColor(
        id: '3',
        colorCode: 'FF0000',
        name: 'Red',
        value: Colors.red,
      ),
      ProductColor(
        id: '4',
        colorCode: '00FF00',
        name: 'Green',
        value: Colors.green,
      ),
      ProductColor(
        id: '5',
        colorCode: '0000FF',
        name: 'Blue',
        value: Colors.blue,
      ),
    ];
  }
}
