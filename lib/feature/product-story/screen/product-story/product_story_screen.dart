import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product-story/data/model/grouped_product_story.dart';
import 'package:flamingo/feature/product-story/data/model/product_story.dart';
import 'package:flamingo/feature/product-story/product_story_engagement_view_model.dart';
import 'package:flamingo/feature/product-story/product_story_view_model.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_screen.dart';
import 'package:flamingo/feature/vendor/screen/vendor-profile/vendor_profile_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/video-view/video_view_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProductStoryScreen extends StatefulWidget {
  const ProductStoryScreen({
    super.key,
    required this.groupedStory,
    this.needVisitProductButton = false,
    this.onRequestNextGroup,
    this.onRequestPreviousGroup,
  });

  final GroupedProductStory groupedStory;
  final bool needVisitProductButton;

  /// Called when the user taps/finishes past the last item in this group —
  /// lets the parent advance the outer (cross-vendor) PageView.
  final VoidCallback? onRequestNextGroup;

  /// Called when the user taps back past the first item in this group.
  final VoidCallback? onRequestPreviousGroup;

  @override
  State<ProductStoryScreen> createState() => _ProductStoryScreenState();
}

class _ProductStoryScreenState extends State<ProductStoryScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _index = 0;
  double _currentProgress = 0.0;

  DateTime? _pointerDownTime;
  Offset? _pointerDownPosition;

  late final AnimationController _dragController;
  late Animation<double> _dragAnimation;
  double _dragOffset = 0;

  int get _itemCount => widget.groupedStory.items.length;

  void _setIndex(int value) {
    setState(() {
      _index = value;
      _currentProgress = 0.0;
    });
  }

  void _goToPrevious() {
    if (_index > 0) {
      _setIndex(_index - 1);
      _pageController.jumpToPage(_index);
    } else {
      widget.onRequestPreviousGroup?.call();
    }
  }

  void _goToNext() {
    if (_index < _itemCount - 1) {
      _setIndex(_index + 1);
      _pageController.jumpToPage(_index);
    } else {
      widget.onRequestNextGroup?.call();
    }
  }

  void _snapBackDrag() {
    _dragAnimation = Tween<double>(begin: _dragOffset, end: 0).animate(
      CurvedAnimation(parent: _dragController, curve: Curves.easeOut),
    )..addListener(() => setState(() => _dragOffset = _dragAnimation.value));
    _dragController.forward(from: 0);
  }

  @override
  void initState() {
    super.initState();
    _index = widget.groupedStory.items.indexWhere((i) =>
        !locator<ProductStoryEngagementViewModel>().hasViewed(i.story.id));
    if (_index == -1) {
      _index = 0;
    }
    _pageController = PageController(initialPage: _index);
    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dismissProgress =
        (_dragOffset / (SizeConfig.screenHeight * 0.4)).clamp(0.0, 1.0);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.black.withOpacity(1 - dismissProgress * 0.5),
        body: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > 0 || _dragOffset > 0) {
              setState(() {
                _dragOffset = (_dragOffset + details.delta.dy).clamp(
                  0.0,
                  SizeConfig.screenHeight,
                );
              });
            }
          },
          onVerticalDragEnd: (details) {
            if (_dragOffset > SizeConfig.screenHeight * 0.15) {
              NavigationHelper.pop(context);
            } else {
              _snapBackDrag();
            }
          },
          child: Transform.translate(
            offset: Offset(0, _dragOffset),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Listener(
                    behavior: HitTestBehavior.translucent,
                    onPointerDown: (event) {
                      _pointerDownTime = DateTime.now();
                      _pointerDownPosition = event.position;
                    },
                    onPointerUp: (event) {
                      final downTime = _pointerDownTime;
                      final downPosition = _pointerDownPosition;
                      if (downTime == null || downPosition == null) return;

                      final elapsed = DateTime.now().difference(downTime);
                      final moved = (event.position - downPosition).distance;
                      // Only treat quick, mostly-stationary taps as navigation —
                      // a hold (pause) or a drag shouldn't also advance the story.
                      if (elapsed < const Duration(milliseconds: 300) &&
                          moved < 12) {
                        final isLeftTap =
                            event.position.dx < SizeConfig.screenWidth / 3;
                        isLeftTap ? _goToPrevious() : _goToNext();
                      }
                    },
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: List.generate(_itemCount, (index) {
                        return ProductStoryItem(
                          story: widget.groupedStory.items[index].story,
                          onProgress: (progress) {
                            if (index == _index && mounted) {
                              setState(() => _currentProgress = progress);
                            }
                          },
                          onVideoEnd: () {
                            if (index == _index) _goToNext();
                          },
                        );
                      }),
                    ),
                  ),
                ),
                _buildStoryHeader(),
                if (widget.needVisitProductButton) _buildVisitProductButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisitProductButton() {
    return Positioned(
      bottom: Dimens.spacingSizeLarge,
      right: Dimens.spacingSizeLarge,
      child: ButtonWidget(
        backgroundColor: AppColors.white,
        height: 40,
        width: 120,
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.spacingSizeSmall,
          vertical: Dimens.spacingSizeExtraSmall,
        ),
        label: 'Visit Product',
        onPressed: () {
          NavigationHelper.push(
            context,
            ProductDetailScreen(
              productId: widget.groupedStory.items[_index].productId,
              title: widget.groupedStory.items[_index].productName,
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Visit Product',
              style: TypographyStyles.bodySmall,
            ),
            Icon(
              Icons.chevron_right,
              size: Dimens.iconSizeSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(_itemCount, (index) {
        double fraction;
        if (index < _index) {
          fraction = 1.0;
        } else if (index == _index) {
          fraction = _currentProgress;
        } else {
          fraction = 0.0;
        }
        return Expanded(
          child: Container(
            height: 2.5,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(Dimens.radius_5),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: fraction,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(Dimens.radius_5),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStoryHeader() {
    return Positioned(
      top: Dimens.spacingSizeSmall + SizeConfig.statusBarHeight,
      right: Dimens.spacingSizeSmall,
      left: Dimens.spacingSizeSmall,
      child: Column(
        children: [
          if (_itemCount > 1) ...[
            _buildProgressBar(),
            const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
          ],
          Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVendorAvatar(),
                    const HorizontalSpaceWidget(
                        width: Dimens.spacingSizeSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => NavigationHelper.push(
                              context,
                              VendorProfileScreen(
                                seller: widget.groupedStory.seller,
                              ),
                            ),
                            child: Text(
                              widget.groupedStory.seller.storeName,
                              style: TypographyStyles.bodyMedium.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            widget.groupedStory.items[_index].productName,
                            style: TypographyStyles.bodySmall.copyWith(
                              color: AppColors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
              GestureDetector(
                onTap: () {
                  NavigationHelper.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: AppColors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVendorAvatar() {
    return GestureDetector(
      onTap: () => NavigationHelper.push(
          context, VendorProfileScreen(seller: widget.groupedStory.seller)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImageWidget(
          image: widget.groupedStory.seller.displayImageUrl ?? "",
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ProductStoryItem extends StatefulWidget {
  const ProductStoryItem({
    super.key,
    required this.story,
    this.onProgress,
    this.onVideoEnd,
  });

  final ProductStory story;
  final void Function(double progress)? onProgress;
  final VoidCallback? onVideoEnd;

  @override
  State<ProductStoryItem> createState() => _ProductStoryItemState();
}

class _ProductStoryItemState extends State<ProductStoryItem> {
  final _viewModel = locator<ProductStoryViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.viewStory(widget.story.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: VideoViewWidget(
        url: widget.story.url,
        coverParent: true,
        looping: false,
        onProgress: widget.onProgress,
        onVideoEnd: widget.onVideoEnd,
      ),
    );
  }
}
