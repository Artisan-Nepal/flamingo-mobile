import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SnippetProductDetailImages extends StatefulWidget {
  const SnippetProductDetailImages({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<String> images;

  @override
  State<SnippetProductDetailImages> createState() =>
      _SnippetProductDetailImagesState();
}

class _SnippetProductDetailImagesState
    extends State<SnippetProductDetailImages> {
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.99999999);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: SizeConfig.screenHeight * 0.5,
      ),
      // height: 200,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (cnxt) => ChangeNotifierProvider.value(
                //       value: Provider.of<ProductDetailViewModel>(context,
                //           listen: false),
                //       builder: (context, child) => ProductDetailsImagesPage(
                //         images: widget.images,
                //         selectedIndex: index,
                //       ),
                //     ),
                //   ),
                // );
              },
              child: CachedNetworkImageWidget(
                image: widget.images[index],
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 10,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: widget.images.length,
                // effect: CustomizableEffect(
                //   spacing: 5,
                //   dotDecoration: DotDecoration(
                //     borderRadius: BorderRadius.circular(30),
                //     height: 3,
                //     width: 20,
                //   ),
                //   activeDotDecoration: DotDecoration(
                //     borderRadius: BorderRadius.circular(30),
                //     height: 3,
                //     width: 20,
                //     color: ColorResources.primaryColor,
                //   ),
                // ),
                effect: ColorTransitionEffect(
                  dotHeight: 2.5,
                  dotWidth: (SizeConfig.screenWidth -
                          5 -
                          2 * Dimens.spacingSizeDefault) /
                      widget.images.length,
                  spacing: 5,
                  activeDotColor: AppColors.primaryMain,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget _buildIndicator(){
  //   return Row(

  //   ),
  // }
}
