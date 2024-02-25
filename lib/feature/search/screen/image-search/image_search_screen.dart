import 'dart:io';

import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/feature/search/screen/image-search/image_search_view_model.dart';
import 'package:flamingo/shared/helper/image_picker_helper.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageSearchScreen extends StatefulWidget {
  const ImageSearchScreen({
    super.key,
    required this.image,
  });

  final File image;

  @override
  State<ImageSearchScreen> createState() => _ImageSearchScreenState();
}

class _ImageSearchScreenState extends State<ImageSearchScreen> {
  final _viewModel = locator<ImageSearchViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.imageSearch(widget.image);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: Consumer<ImageSearchViewModel>(
        builder: (context, viewModel, child) {
          final products = viewModel.imageSearchUseCase.data ?? [];
          return DefaultScreen(
            appBarTitle: Text('Search Result'),
            appBarActions: [
              GestureDetector(
                onTap: viewModel.imageSearchUseCase.isLoading
                    ? null
                    : _onCameraSearch,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: Dimens.spacingSizeDefault),
                  child: Icon(
                    CupertinoIcons.camera,
                    size: Dimens.iconSize_20,
                    color: !viewModel.imageSearchUseCase.isLoading
                        ? AppColors.black
                        : AppColors.grayMain,
                  ),
                ),
              )
            ],
            padding: EdgeInsets.zero,
            scrollable: false,
            child: viewModel.imageSearchUseCase.isLoading
                ? DefaultScreenLoaderWidget()
                : viewModel.imageSearchUseCase.hasError
                    ? DefaultErrorWidget(
                        errorMessage: viewModel.imageSearchUseCase.exception!,
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Image.file(
                              widget.image,
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.screenHeight * 0.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.spacingSizeSmall,
                                vertical: Dimens.spacingSizeLarge,
                              ),
                              child: Text(
                                'Products in this photo',
                                style: textTheme(context).bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                          SnippetProductListing(
                            products: products,
                            useSliver: true,
                            padding: Dimens.spacingSizeSmall,
                          ),
                        ],
                      ),
          );
        },
      ),
    );
  }

  _onCameraSearch() async {
    final image = await ImagePickerHelper.pickImage(
      context,
      crop: true,
      cropperTitle: 'Crop image to search',
      cropperDoneButtonTitle: 'Search',
    );
    if (image == null) return;

    NavigationHelper.pushReplacement(context, ImageSearchScreen(image: image));
  }
}
