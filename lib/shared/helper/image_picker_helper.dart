import 'dart:io';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<File?> pickImageFromCamera(BuildContext context) async {
    var temp = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 50,
    );
    if (temp != null) {
      return File(temp.path);
    }
    return null;
  }

  static Future<File?> pickImageFromGallery(BuildContext context) async {
    var temp = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (temp != null) {
      return File(temp.path);
    }
    return null;
  }

  static Future<List<File>?> pickMultipleImageFromGallery(
      BuildContext context) async {
    var temps = await ImagePicker().pickMultiImage(
      imageQuality: 50,
    );
    List<File>? files;
    files = [];
    for (var temp in temps) {
      files.add(File(temp.path));
    }
    return files;
  }

  static Future<File?> pickVideoFromGallery(BuildContext context) async {
    var temp = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (temp != null) {
      return File(temp.path);
    }
    return null;
  }

  static Future<File?> pickImage(BuildContext context) async {
    var imageSource = await _showImageSourcePicker(context);
    var temp = await ImagePicker().pickImage(
      source: imageSource,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 50,
    );
    if (temp != null) {
      return File(temp.path);
    }
    return null;
  }

  static Future<dynamic> _showImageSourcePicker(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(
              Icons.image,
              color: AppColors.primaryMain,
            ),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.camera_alt,
              color: AppColors.primaryMain,
            ),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }
}
