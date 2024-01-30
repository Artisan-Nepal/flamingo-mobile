import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/video-view/video_view_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SnippetAdvertisementImages extends StatefulWidget {
  const SnippetAdvertisementImages({
    Key? key,
    required this.images,
    this.primaryVideo,
  }) : super(key: key);

  final List<String> images;
  final String? primaryVideo;

  @override
  State<SnippetAdvertisementImages> createState() =>
      _SnippetAdvertisementImagesState();
}

class _SnippetAdvertisementImagesState
    extends State<SnippetAdvertisementImages> {
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.99999999);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hasVideo = widget.primaryVideo != null;
    return Container(
      height: SizeConfig.screenHeight * 0.45,
      // height: 200,
      width: double.infinity,
      child: Column(
        // alignment: Alignment.center,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount:
                  hasVideo ? widget.images.length + 1 : widget.images.length,
              itemBuilder: (context, i) {
                if (i == 0 && hasVideo) {
                  return Container(
                    child: VideoViewWidget(
                      url: widget.primaryVideo!,
                      coverParent: true,
                      loaderColor: AppColors.black,
                      behaviour: VideoViewBehaviour.pausable,
                    ),
                  );
                }
                final index = hasVideo ? i - 1 : i;
                return Container(
                  color: AppColors.grayLighter,
                  child: CachedNetworkImageWidget(
                    image: widget.images[index],
                    fit: BoxFit.cover,
                    needPlaceHolder: false,
                  ),
                );
              },
            ),
          ),
          VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
          _buildIndicator(),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    final hasVideo = widget.primaryVideo != null;

    final totalItems =
        hasVideo ? widget.images.length + 1 : widget.images.length;
    if (totalItems < 2) return const SizedBox();
    return SmoothPageIndicator(
      controller: _pageController,
      count: totalItems,
      effect: ColorTransitionEffect(
        dotHeight: 5,
        dotWidth: 25,
        spacing: 5,
        activeDotColor: AppColors.primaryMain,
      ),
    );
  }
}
