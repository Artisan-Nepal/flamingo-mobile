import 'dart:io';

import 'package:flamingo/feature/upload-file/data/model/upload_file_request.dart';
import 'package:flamingo/feature/upload-file/data/model/upload_file_response.dart';
import 'package:flamingo/feature/upload-file/data/upload_file_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class UploadFileViewModel extends ChangeNotifier {
  final UploadFileRepository _uploadFileRepository;

  UploadFileViewModel({required UploadFileRepository uploadFileRepository})
      : _uploadFileRepository = uploadFileRepository;

  File? _selectedImage;
  Response<UploadFileResponse> _uploadFileUseCase =
      Response<UploadFileResponse>();

  Response<UploadFileResponse> get uploadFileUseCase => _uploadFileUseCase;

  File? get selectedImage => _selectedImage;

  Future<void> setSelectedFile(File image) async {
    _selectedImage = image;
    notifyListeners();

    await _upload();
  }

  void setUploadFileUseCase(Response<UploadFileResponse> response) {
    _uploadFileUseCase = response;
    notifyListeners();
  }

  Future<void> _upload() async {
    try {
      if (_selectedImage == null) {
        throw Exception('Image not selected.');
      }
      setUploadFileUseCase(Response.loading());
      final response = await _uploadFileRepository
          .upload(UploadFileRequest(file: _selectedImage!));
      setUploadFileUseCase(Response.complete(response));
    } catch (exception) {
      setUploadFileUseCase(Response.error(exception));
    }
  }
}
