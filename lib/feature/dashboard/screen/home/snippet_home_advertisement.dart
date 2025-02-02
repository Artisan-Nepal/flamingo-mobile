import 'package:flamingo/feature/advertisement/advertisement_listing_view_model.dart';
import 'package:flamingo/feature/advertisement/screen/advertisement_screen.dart';
import 'package:flamingo/shared/shared.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<AdvertisementListingViewModel>(
      builder: (context, viewModel, child) {
        final advertisements = viewModel.getAdvertisementsUseCase.data ?? [];

        if (viewModel.getAdvertisementsUseCase.isLoading) {
          return _buildLoader();
        }

        if (advertisements.isEmpty) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacingSizeSmall),
                child: TextWidget(
                  'EXPLORE',
                  style: textTheme(context).bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
              SizedBox(
                width: double.infinity,
                child: CarouselSlider.builder(
                  carouselController: _sliderController,
                  options: CarouselOptions(
                    enableInfiniteScroll: true,
                    viewportFraction: 0.99,
                    disableCenter: true,
                    autoPlay: advertisements.length == 1 ? false : true,
                    scrollPhysics: advertisements.length == 1
                        ? NeverScrollableScrollPhysics()
                        : AlwaysScrollableScrollPhysics(),
                    // enlargeCenterPage: true,
                    autoPlayInterval: const Duration(seconds: 8),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 300),
                    height: SizeConfig.screenHeight * 0.6,
                  ),
                  itemCount: advertisements.length,
                  itemBuilder: (context, index, pgIndex) {
                    return SninppetHomeAdvertisementItem(
                      onTap: () {
                        NavigationHelper.push(
                          context,
                          AdvertisementScreen(
                            advertisement: advertisements[index],
                          ),
                        );
                      },
                      image: advertisements[index].primaryImageUrl,
                      title: advertisements[index].title,
                      body: advertisements[index].vendor.seller.storeName,
                    );
                  },
                ),
              ),
              VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.grayLighter,
            height: 15,
            width: 200,
          ),
          VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
          Container(
            height: SizeConfig.screenHeight * 0.5,
            width: double.infinity,
            color: AppColors.grayLighter,
          ),
          VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
        ],
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
        margin: const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
        width: double.infinity,
        color: AppColors.transparent,
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
            Row(
              children: [
                Expanded(
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
                HorizontalSpaceWidget(width: Dimens.spacingSizeDefault),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.grayDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
