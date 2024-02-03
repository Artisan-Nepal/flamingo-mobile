import 'dart:io';
import 'package:flamingo/feature/dashboard/screen/account/change_display_picture_view_model.dart';
import 'package:flamingo/shared/helper/image_picker_helper.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/alert-dialog/alert_dialog_widget.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';

class ChangeDisplayPictureScreen extends StatefulWidget {
  const ChangeDisplayPictureScreen({Key? key}) : super(key: key);

  @override
  State<ChangeDisplayPictureScreen> createState() =>
      _ChangeDisplayPictureScreenState();
}

class _ChangeDisplayPictureScreenState
    extends State<ChangeDisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeDisplayPictureViewModel>(
      builder: (context, viewModel, child) {
        return DefaultScreen(
          appBarTitle: Text('New Profile Photo'),
          appBarLeading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          appBarActions: [
            !viewModel.changeDisplayPictureUseCase.isLoading
                ? IconButton(
                    onPressed: () {
                      _handleOnChange(viewModel);
                    },
                    icon: const Icon(Icons.check),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: SpinKitDualRing(
                            color: Colors.black,
                            size: 35,
                            lineWidth: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
          child: Column(children: [
            // Image
            if (viewModel.croppedImage != null)
              Container(
                margin: const EdgeInsets.all(Dimens.spacingSizeDefault),
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.grayLight,
                  ),
                ),
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99999),
                  child: Image.file(
                    viewModel.croppedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // Edit buttons
            Container(
              color: AppColors.primaryMain,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmallButtonWidget(
                    height: 50,
                    width: 50,
                    onPressed: () {
                      _cropImage(viewModel);
                    },
                    icon: Icons.crop,
                  ),
                  const SizedBox(width: 30),
                  SmallButtonWidget(
                    height: 50,
                    width: 50,
                    onPressed: () async {
                      final image = await ImagePickerHelper.pickImage(context);
                      if (image != null) {
                        viewModel.setSelectedImage(image);
                      }
                    },
                    icon: Icons.add_a_photo_rounded,
                  ),
                  const SizedBox(width: 30),
                  SmallButtonWidget(
                    height: 50,
                    width: 50,
                    onPressed: () {
                      _clearImage(viewModel);
                    },
                    icon: Icons.delete,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ]),
        );
      },
    );
  }

  _handleOnChange(ChangeDisplayPictureViewModel viewModel) async {
    await viewModel.changeDisplayPicture();

    if (viewModel.changeDisplayPictureUseCase.hasCompleted) {
      NavigationHelper.pop(context);
    } else {
      showToast(context,
          message: viewModel.changeDisplayPictureUseCase.exception,
          isSuccess: false);
    }
  }

  _cropImage(ChangeDisplayPictureViewModel viewModel) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: viewModel.selectedImage!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.circle,
    );
    if (cropped != null) {
      viewModel.setCroppedImage(File(cropped.path));
    }
  }

  _clearImage(ChangeDisplayPictureViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        title: 'Remove selection?',
        description: 'Are you sure you want to remove selection?',
        needSecondButton: true,
        firstButtonOnPressed: () {
          viewModel.clearSelectedImage();
          NavigationHelper.popUntil(context, 2);
        },
      ),
    );
  }
}
