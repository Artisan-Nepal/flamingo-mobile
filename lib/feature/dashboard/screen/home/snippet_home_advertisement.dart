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
  late CarouselSliderController _sliderController;

  @override
  void initState() {
    _sliderController = CarouselSliderController();
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
        // A controlled editorial image size (4:5 portrait off the full content
        // width) instead of a raw fraction of screen height - keeps the ad the
        // same shape on every device and stops it eating ~60% of the screen.
        final double adImageWidth =
            SizeConfig.screenWidth - Dimens.spacingSizeSmall * 2;
        final double adImageHeight = adImageWidth * 5 / 4;
        // Room for the grand caption block below the image: a large title (up to
        // 2 lines) plus the vendor's description (up to 2 lines).
        final double carouselHeight = adImageHeight + 150;
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
                    viewportFraction: 1,
                    disableCenter: true,
                    autoPlay: advertisements.length == 1 ? false : true,
                    scrollPhysics: advertisements.length == 1
                        ? NeverScrollableScrollPhysics()
                        : AlwaysScrollableScrollPhysics(),
                    autoPlayInterval: const Duration(seconds: 8),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 300),
                    height: carouselHeight,
                  ),
                  itemCount: advertisements.length,
                  itemBuilder: (context, index, pgIndex) {
                    return SninppetHomeAdvertisementItem(
                      imageHeight: adImageHeight,
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
                      description: advertisements[index].description,
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
    final double adImageWidth =
        SizeConfig.screenWidth - Dimens.spacingSizeSmall * 2;
    final double adImageHeight = adImageWidth * 5 / 4;
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: adImageHeight,
              width: double.infinity,
              color: AppColors.grayLighter,
            ),
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
    required this.description,
    required this.imageHeight,
    this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final String? description;
  final double imageHeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasDescription = description != null && description!.trim().isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
        width: double.infinity,
        color: AppColors.transparent,
        child: Column(
          // Fill the carousel's fixed height and top-align, so the image never
          // shifts vertically as captions vary in length between slides.
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: imageHeight,
                width: double.infinity,
                color: AppColors.grayLighter,
                child: CachedNetworkImageWidget(
                  image: image,
                  fit: BoxFit.cover,
                  needPlaceHolder: false,
                ),
              ),
            ),
            VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
            // Full-width, left-aligned editorial caption - a large bold title
            // over the vendor's description - modeled on the reference layout.
            // The whole card is tappable, so no trailing affordance competes
            // with the headline.
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                // Variable-font weight axis - the reliable way to hit a specific
                // weight on a variable TTF across platforms.
                fontVariations: [FontVariation('wght', 600)],
                fontWeight: FontWeight.w600,
                fontSize: Dimens.fontSizeHuge,
                height: 1.15,
                letterSpacing: -0.2,
                color: AppColors.black,
              ),
            ),
            if (hasDescription) ...[
              VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
              Text(
                description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontVariations: [FontVariation('wght', 400)],
                  fontSize: Dimens.fontSizeLarge,
                  height: 1.4,
                  color: AppColors.grayDark,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
