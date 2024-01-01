import 'dart:io';

import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/upload-file/data/model/upload_file_request.dart';
import 'package:flamingo/feature/upload-file/data/upload_file_repository.dart';
import 'package:flamingo/feature/user/data/model/update_user_request.dart';
import 'package:flamingo/feature/user/data/user_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class ChangeDisplayPictureViewModel extends ChangeNotifier {
  final UploadFileRepository _uploadFileRepository;
  final UserRepository _userRepository;

  ChangeDisplayPictureViewModel({
    required UploadFileRepository uploadFileRepository,
    required UserRepository userRepository,
  })  : _uploadFileRepository = uploadFileRepository,
        _userRepository = userRepository;

  File? _selectedImage;
  File? _croppedImage;
  Response _changeDisplayPictureUseCase = Response();

  Response get changeDisplayPictureUseCase => _changeDisplayPictureUseCase;

  File? get selectedImage => _selectedImage;
  File? get croppedImage => _croppedImage;

  clearSelectedImage() {
    _selectedImage = null;
  }

  clearCroppedImage() {
    _croppedImage = null;
  }

  Future<void> setCroppedImage(File image) async {
    _croppedImage = image;
    notifyListeners();
  }

  Future<void> setSelectedImage(File image) async {
    _selectedImage = image;
    _croppedImage = image;
    notifyListeners();
  }

  void setChangeDisplayPictureUseCase(Response response) {
    _changeDisplayPictureUseCase = response;
    notifyListeners();
  }

  Future<void> changeDisplayPicture() async {
    setChangeDisplayPictureUseCase(Response.loading());

    try {
      final uploadResponse = await _uploadFileRepository
          .upload(UploadFileRequest(file: _selectedImage!));

      final response = await _userRepository.updateCustomer(
          UpdateUserRequest(displayImageUrl: uploadResponse.url));
      locator<AuthViewModel>().syncRemotely();
      setChangeDisplayPictureUseCase(Response.complete(response));
    } catch (exception) {
      setChangeDisplayPictureUseCase(Response.error(exception));
    }
  }
}
