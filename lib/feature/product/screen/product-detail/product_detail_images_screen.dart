import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailImageScreen extends StatefulWidget {
  const ProductDetailImageScreen({
    Key? key,
    required this.variants,
    required this.selectedIndex,
  }) : super(key: key);

  final List<ProductVariant> variants;
  final int selectedIndex;

  @override
  State<ProductDetailImageScreen> createState() =>
      _ProductDetailImageScreenState();
}

class _ProductDetailImageScreenState extends State<ProductDetailImageScreen> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
        initialPage: widget.selectedIndex, viewportFraction: 0.9999999);
    // Hide status bar
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    // Show Status bar
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: SystemUiOverlay.values);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.center,
          children: [
            // Interactive Image
            PageView.builder(
              controller: _pageController,
              itemCount: widget.variants.length,
              itemBuilder: (context, index) => InteractiveViewer(
                child: CachedNetworkImageWidget(
                  image: widget.variants[index].image.url,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            // Back Button
            Positioned(
              top: SizeConfig.statusBarHeight + 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.all(0),
                height: 35,
                width: 35,
                decoration: const BoxDecoration(
                  color: AppColors.grayLight,
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),

            // Images List
            if (widget.variants.length > 1)
              Positioned(
                bottom: 10,
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.variants.length,
                  effect: ColorTransitionEffect(
                    dotHeight: 2.5,
                    dotWidth: (SizeConfig.screenWidth -
                            5 -
                            2 * Dimens.spacingSizeDefault) /
                        widget.variants.length,
                    spacing: 5,
                    activeDotColor: AppColors.primaryMain,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
