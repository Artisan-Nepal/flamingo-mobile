import 'package:flamingo/feature/advertisement/advertisement_listing_view_model.dart';
import 'package:flamingo/shared/util/util.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SnippetHomeAdvertisement extends StatefulWidget {
  const SnippetHomeAdvertisement({Key? key}) : super(key: key);

  @override
  State<SnippetHomeAdvertisement> createState() =>
      _SnippetHomeAdvertisementState();
}

class _SnippetHomeAdvertisementState extends State<SnippetHomeAdvertisement> {
  late CarouselControllerImpl _sliderController;

  @override
  void initState() {
    _sliderController = CarouselControllerImpl();
    super.initState();
  }

  int _sliderIndex = 0;

  setSliderIndex(int value) {
    _sliderIndex = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdvertisementListingViewModel>(
      builder: (context, viewModel, child) {
        final advertisements =
            viewModel.getAdvertisementsUseCase.data?.rows ?? [];
        final hasSingleItem = advertisements.length == 1;

        if (viewModel.getAdvertisementsUseCase.isLoading) {
          return Container(
            height: SizeConfig.screenHeight * 0.4,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
            color: AppColors.grayLighter,
          );
        }

        if (advertisements.isEmpty) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: CarouselSlider.builder(
                  carouselController: _sliderController,
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    viewportFraction: hasSingleItem ? 0.95 : 0.85,
                    disableCenter: true,
                    scrollPhysics: hasSingleItem
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    autoPlay: false,
                    // enlargeCenterPage: true,
                    autoPlayInterval: const Duration(seconds: 8),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 300),
                    onPageChanged: (index, changedReason) {
                      setSliderIndex(index);
                    },
                    height: SizeConfig.screenHeight * 0.5,
                  ),
                  itemCount: advertisements.length,
                  itemBuilder: (context, index, pgIndex) {
                    return SninppetHomeAdvertisementItem(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Products(
                        //       slider: provider.sliderList[index],
                        //       name: provider.sliderList[index].title,
                        //       id: provider.sliderList[index].categoryId,
                        //       productType: ProductType.categoryProduct,
                        //     ),
                        //   ),
                        // );
                      },
                      image: advertisements[index].images.first.url,
                      title: advertisements[index].title,
                      body: advertisements[index].description,
                    );
                  },
                ),
              ),
              VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
              if (advertisements.length > 1)
                SizedBox(
                  width: SizeConfig.screenWidth,
                  child: _buildDots(advertisements.length),
                ),
            ],
          ),
        );
      },
    );
  }

  _buildDots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: 8,
            width: 8,
            margin: const EdgeInsets.only(
              right: Dimens.spacingSizeExtraSmall,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: index == _sliderIndex
                  ? AppColors.primaryMain
                  : AppColors.grayLight,
            ),
          );
        },
      ),
    );
  }
}

class SninppetHomeAdvertisementItem extends StatelessWidget {
  const SninppetHomeAdvertisementItem({
    Key? key,
    required this.image,
    required this.title,
    required this.body,
    this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final String body;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: Dimens.spacingSizeExtraSmall),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: AppColors.grayLighter,
                width: double.infinity,
                child: CachedNetworkImageWidget(
                  image: image,
                  fit: BoxFit.cover,
                  needPlaceHolder: false,
                ),
              ),
            ),
            VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
            Container(
              padding: const EdgeInsets.only(right: Dimens.spacingSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Dimens.fontSizeExtraLarge,
                        color: AppColors.black),
                  ),
                  VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
                  Text(
                    body,
                    style: const TextStyle(
                      fontSize: Dimens.fontSizeLarge,
                      color: AppColors.primaryMain,
                    ),
                    textAlign: TextAlign.right,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
