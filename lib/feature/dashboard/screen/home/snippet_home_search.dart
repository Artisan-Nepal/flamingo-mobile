import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flamingo/feature/search/screen/image-search/image_search_screen.dart';
import 'package:flamingo/feature/search/screen/text-search/search_screen.dart';
import 'package:flamingo/shared/helper/image_picker_helper.dart';
import 'package:flamingo/shared/shared.dart';

import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnippetHomeSearch extends StatelessWidget {
  const SnippetHomeSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grayLighter,
        borderRadius: BorderRadius.circular(Dimens.radius_5),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.spacingSizeDefault,
        vertical: Dimens.spacingSizeExtraSmall,
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_outlined,
            color: AppColors.grayMain,
          ),
          HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
          Expanded(
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Search for products',
                  cursor: '|',
                  speed: const Duration(milliseconds: 100),
                  textStyle: TextStyle(color: AppColors.grayDark),
                ),
                TypewriterAnimatedText(
                  cursor: '|',
                  'Search with image',
                  speed: const Duration(milliseconds: 100),
                  textStyle: TextStyle(color: AppColors.grayDark),
                ),
                TypewriterAnimatedText(
                  cursor: '|',
                  'Search your favorite brands',
                  speed: const Duration(milliseconds: 100),
                  textStyle: TextStyle(color: AppColors.grayDark),
                ),
              ],
              repeatForever: true,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: false,
              stopPauseOnTap: true,
              onTap: () {
                NavigationHelper.pushWithoutAnimation(
                  context,
                  const SearchScreen(
                    isInitial: true,
                  ),
                );
              },
            ),
          ),
          HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
          GestureDetector(
            onTap: () {
              _onCameraSearch(context);
            },
            child: Icon(
              CupertinoIcons.camera,
              size: Dimens.iconSize_20,
              color: AppColors.grayMain,
            ),
          )
        ],
      ),
    );
  }

  _onCameraSearch(BuildContext context) async {
    final image = await ImagePickerHelper.pickImage(
      context,
      crop: true,
      cropperTitle: 'Crop image to search',
      cropperDoneButtonTitle: 'Search',
    );
    if (image == null) return;

    NavigationHelper.push(context, ImageSearchScreen(image: image));
  }
}
