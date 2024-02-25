import 'dart:io';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/bottom-sheet/bottom_sheet_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
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

  static Future<File?> pickImage(
    BuildContext context, {
    bool crop = false,
    CropAspectRatio? cropperAspectRatio,
    String? cropperTitle,
    String? cropperDoneButtonTitle,
    String? cropperCancelButtonTitle,
  }) async {
    var imageSource = await _showImageSourcePicker(context);
    var temp = await ImagePicker().pickImage(
      source: imageSource,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 50,
    );
    if (temp != null) {
      return await cropImage(
        temp,
        aspectRatio: cropperAspectRatio,
        title: cropperTitle,
        doneButtonTitle: cropperDoneButtonTitle,
        cancelButtonTitle: cropperCancelButtonTitle,
      );
    }
    return null;
  }

  static Future<File?> cropImage(
    XFile image, {
    CropAspectRatio? aspectRatio,
    String? title = "Crop Image",
    String? doneButtonTitle = 'Done',
    String? cancelButtonTitle = 'Cancel',
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    final cropped = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: aspectRatio ?? CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: cropStyle,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: title,
            toolbarColor: AppColors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: title,
            doneButtonTitle: doneButtonTitle,
            cancelButtonTitle: cancelButtonTitle,
          ),
        ]);
    if (cropped != null) return File(cropped.path);
    return null;
  }

  static Future<dynamic> _showImageSourcePicker(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: BottomSheetWidget(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    CupertinoIcons.photo_on_rectangle,
                    color: AppColors.primaryMain,
                  ),
                  title: Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    CupertinoIcons.photo_camera_solid,
                    color: AppColors.primaryMain,
                  ),
                  title: Text('Camera'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
