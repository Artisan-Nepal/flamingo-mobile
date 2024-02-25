import 'dart:io';

import 'package:dio/dio.dart';

class ImageSearchRequest {
  final File image;

  ImageSearchRequest({
    required this.image,
  });

  Future<Map<String, dynamic>> toJson() async => {
        "image": await MultipartFile.fromFile(image.path),
      };
}
