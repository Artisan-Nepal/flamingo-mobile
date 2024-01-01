import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/dashboard/screen/account/change_display_picture_screen.dart';
import 'package:flamingo/feature/dashboard/screen/account/change_display_picture_view_model.dart';
import 'package:flamingo/shared/helper/image_picker_helper.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SnippetDisplayPicture extends StatefulWidget {
  const SnippetDisplayPicture({
    super.key,
    this.existingDisplayPicture,
  });

  final String? existingDisplayPicture;

  @override
  State<SnippetDisplayPicture> createState() => _SnippetDisplayPictureState();
}

class _SnippetDisplayPictureState extends State<SnippetDisplayPicture> {
  final _viewModel = locator<ChangeDisplayPictureViewModel>();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: Consumer<ChangeDisplayPictureViewModel>(
        builder: (context, viewModel, child) {
          return Stack(
            children: [
              ClipOval(
                child: authViewModel.isLoggedIn &&
                        authViewModel.user?.displayImageUrl != null
                    ? CachedNetworkImageWidget(
                        placeHolder: ImageConstants.displayPicturePlaceHolder,
                        image: authViewModel.user!.displayImageUrl!,
                        fit: BoxFit.cover,
                        height: SizeConfig.screenHeight * 0.1,
                        width: SizeConfig.screenHeight * 0.1,
                      )
                    : Image.asset(
                        ImageConstants.displayPicturePlaceHolder,
                        height: SizeConfig.screenHeight * 0.1,
                        width: SizeConfig.screenHeight * 0.1,
                      ),
              ),
              // Edit icon
              if (authViewModel.isLoggedIn)
                Positioned(
                  right: 0,
                  bottom: 4,
                  child: GestureDetector(
                    onTap: !authViewModel.isLoggedIn
                        ? null
                        : () async {
                            // if new pp has not been selected
                            if (viewModel.selectedImage == null) {
                              final image =
                                  await ImagePickerHelper.pickImage(context);
                              if (image != null) {
                                viewModel.setSelectedImage(image);
                                NavigationHelper.push(
                                  context,
                                  ChangeNotifierProvider.value(
                                    value: viewModel,
                                    child: const ChangeDisplayPictureScreen(),
                                  ),
                                );
                              }
                              // if new pp has been selected
                            } else {
                              NavigationHelper.push(
                                context,
                                ChangeNotifierProvider.value(
                                  value: viewModel,
                                  child: const ChangeDisplayPictureScreen(),
                                ),
                              );
                            }
                          },
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primaryMain,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          color: Colors.white,
                          child: const Icon(
                            Icons.edit,
                            size: 13,
                            color: AppColors.primaryMain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
