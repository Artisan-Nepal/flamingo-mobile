import 'dart:io';

import 'package:dio/dio.dart';

class UploadFileRequest {
  final File file;

  UploadFileRequest({
    required this.file,
  });

  Future<Map<String, dynamic>> toJson() async => {
        "file": await MultipartFile.fromFile(file.path),
      };
}
