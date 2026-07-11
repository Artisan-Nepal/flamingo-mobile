import 'package:collection/collection.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/customer-activity/create_activity_view_model.dart';
import 'package:flamingo/feature/product-story/data/model/grouped_product_story.dart';
import 'package:flamingo/feature/product-story/data/model/product_story.dart';
import 'package:flamingo/feature/product-story/product_story_engagement_view_model.dart';
import 'package:flamingo/feature/product-story/product_story_view_model.dart';
import 'package:flamingo/feature/product-story/screen/product-story/grouped_product_story_screen.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_filter_products_bottomsheet.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/feature/vendor/data/model/seller.dart';
import 'package:flamingo/feature/vendor/favourite_vendor_view_model.dart';
import 'package:flamingo/feature/vendor/screen/vendor-profile/vendor_profile_view_model.dart';
import 'package:flamingo/shared/constant/user_activity_type.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/fav-button/fav_vendor_button_widget.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/store-avatar/store_avatar_widget.dart';
import 'package:flamingo/widget/shimmer/shimmer.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({
    super.key,
    required this.seller,
  });

  final Seller seller;

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final _productListingViewModel = locator<ProductListingViewModel>();
  final _viewModel = locator<VendorProfileViewModel>();
  final _productStoryViewModel = locator<ProductStoryViewModel>();
  String? _selectedCategory;

  void initState() {
    super.initState();
    getData();
  }

  logActivity() async {
    await locator<CreateActivityViewModel>().createUserActivity(
      sellerId: widget.seller.id,
      activityType: UserActivityType.viewVendor,
    );
  }

  getData() async {
    await _viewModel.getVendorBySellerId(widget.seller.id);
    if (_viewModel.vendorUseCase.hasCompleted) {
      final vendor = _viewModel.vendorUseCase.data!;
      locator<FavouriteVendorViewModel>().getVendorLikes(vendor.id);
      _productStoryViewModel.getVendorStories(vendor.id);
    }

    await _productListingViewModel.getSellerProducts(widget.seller.id);

    if (_productListingViewModel.getProductsUseCase.hasCompleted) {
      await logActivity();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _productListingViewModel,
        ),
        ChangeNotifierProvider(
          create: (context) => _viewModel,
        ),
        ChangeNotifierProvider(
          create: (context) => _productStoryViewModel,
        ),
      ],
      child: DefaultScreen(
        padding: EdgeInsets.zero,
        appBarTitle: Text(
          widget.seller.storeName,
          style: textTheme(context).titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        appBarActions: [
          Padding(
            padding: const EdgeInsets.only(right: Dimens.spacingSizeDefault),
            child: Consumer<VendorProfileViewModel>(
              builder: (context, viewModel, child) => FavVendorButtonWidget(
                vendorId: viewModel.vendorUseCase.data?.id ?? '',
                iconSize: Dimens.iconSize_22,
                enabled: viewModel.vendorUseCase.hasCompleted,
              ),
            ),
          ),
        ],
        scrollable: false,
        child: SafeArea(
          child: Consumer<ProductListingViewModel>(
            builder: (context, productListingViewModel, child) {
              return CustomScrollView(
                slivers: [
                  Consumer<VendorProfileViewModel>(
                      builder: (context, viewModel, child) {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          VerticalSpaceWidget(
                              height: Dimens.spacingSizeDefault),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.grayLighter,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: StoreAvatarWidget(
                              name: widget.seller.storeName,
                              imageUrl: widget.seller.displayImageUrl,
                              size: SizeConfig.screenHeight * 0.1,
                            ),
                          ),
                          VerticalSpaceWidget(
                              height: Dimens.spacingSizeSmall),
                          Consumer<FavouriteVendorViewModel>(
                            builder:
                                (context, favouriteVendorViewModel, child) {
                              final likes =
                                  favouriteVendorViewModel.getVendorLikeCount(
                                viewModel.vendorUseCase.data?.id ?? '',
                              );
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    size: Dimens.iconSizeExtraSmall,
                                    color: AppColors.grayLight,
                                  ),
                                  const HorizontalSpaceWidget(
                                      width: Dimens.spacing_2),
                                  Text(
                                    '$likes ${likes == 1 ? 'like' : 'likes'}',
                                    style: textTheme(context)
                                        .bodySmall!
                                        .copyWith(color: AppColors.grayMain),
                                  ),
                                ],
                              );
                            },
                          ),
                          VerticalSpaceWidget(
                              height: Dimens.spacingSizeDefault),
                        ],
                      ),
                    );
                  }),
                  _buildStoriesRow(productListingViewModel),
                  if (productListingViewModel.getProductsUseCase.data?.rows
                          .isNotEmpty ==
                      true)
                    _buildRefineAndCategoryRow(productListingViewModel),
                  ..._buildProductListing(productListingViewModel)
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStoriesRow(ProductListingViewModel productListingViewModel) {
    return Consumer<ProductStoryViewModel>(
      builder: (context, storyViewModel, child) {
        final stories = storyViewModel.vendorStoriesUseCase.data ?? [];
        if (storyViewModel.vendorStoriesUseCase.isLoading) {
          return const SliverToBoxAdapter(child: SizedBox());
        }
        if (!storyViewModel.vendorStoriesUseCase.hasCompleted ||
            stories.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox());
        }

        final products = productListingViewModel.getProductsUseCase.data?.rows;

        return Consumer<ProductStoryEngagementViewModel>(
          builder: (context, engagementViewModel, child) {
            return SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.spacingSizeSmall,
                    ),
                    child: Text(
                      'STORIES',
                      style: textTheme(context).bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                  SizedBox(
                    height: 92,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: stories.length,
                      itemBuilder: (context, index) {
                        final story = stories[index];
                        final hasViewed = engagementViewModel.hasViewed(story.id);
                        final matchedProduct = products?.firstWhereOrNull(
                          (p) => p.id == story.productId,
                        );
                        final thumbnail = matchedProduct != null
                            ? extractProductDefaultImage(
                                matchedProduct.images,
                                matchedProduct.variants,
                              )
                            : (widget.seller.displayImageUrl ?? '');

                        return GestureDetector(
                          onTap: () => _openVendorStories(stories, products),
                          child: Container(
                            width: 72,
                            margin: EdgeInsets.only(
                              left: index == 0 ? Dimens.spacingSizeSmall : 0,
                              right: Dimens.spacingSizeSmall,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: hasViewed
                                      ? AppColors.grayLight
                                      : AppColors.secondaryMain,
                                  width: hasViewed ? 1.5 : 2.5,
                                ),
                              ),
                              padding: const EdgeInsets.all(2.5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CachedNetworkImageWidget(
                                      image: thumbnail,
                                      height: 68,
                                      width: 68,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      height: 68,
                                      width: 68,
                                      color: AppColors.black.withOpacity(0.18),
                                    ),
                                    Icon(
                                      Icons.play_arrow_rounded,
                                      color: AppColors.white,
                                      size: Dimens.iconSizeLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openVendorStories(
    List<ProductStory> stories,
    List<ProductDetail>? products,
  ) {
    final items = stories.map((story) {
      final matchedProduct = products?.firstWhereOrNull(
        (p) => p.id == story.productId,
      );
      return GroupedProductStoryItem(
        productId: story.productId ?? '',
        productName: matchedProduct?.title ?? widget.seller.storeName,
        productImage: matchedProduct != null
            ? extractProductDefaultImage(
                matchedProduct.images,
                matchedProduct.variants,
              )
            : (widget.seller.displayImageUrl ?? ''),
        story: story,
      );
    }).toList();

    NavigationHelper.push(
      context,
      GroupedProductStoriesScreen(
        groupedStories: [
          GroupedProductStory(seller: widget.seller, items: items),
        ],
      ),
    );
  }

  Widget _buildRefineAndCategoryRow(ProductListingViewModel viewModel) {
    final categories = <String>{
      for (final p in viewModel.getProductsUseCase.data?.rows ?? [])
        if (p.categoryName != null) p.categoryName!
    }.toList();

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding:
              const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
          children: [
            ButtonWidget(
              label: 'Refine',
              height: 36,
              width: null,
              needBorder: true,
              backgroundColor: AppColors.transparent,
              textColor: AppColors.grayDarker,
              fontWeight: FontWeight.w600,
              borderRaidus: BorderRadius.circular(Dimens.radiusSmall),
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spacingSizeDefault,
              ),
              onPressed: () => _onPressFilter(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.tune, size: Dimens.iconSizeSmall),
                  HorizontalSpaceWidget(width: Dimens.spacingSizeExtraSmall),
                  Text(
                    'Refine',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            _buildCategoryChip(null),
            const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            for (final category in categories) ...[
              _buildCategoryChip(category),
              const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String? category) {
    final isSelected = _selectedCategory == category;
    return ButtonWidget(
      label: category ?? 'All',
      height: 36,
      width: null,
      needBorder: true,
      borderColor: isSelected ? AppColors.grayDarker : AppColors.grayLight,
      backgroundColor:
          isSelected ? AppColors.grayDarker : AppColors.transparent,
      textColor: isSelected ? AppColors.white : AppColors.grayDarker,
      fontWeight: FontWeight.w600,
      borderRaidus: BorderRadius.circular(Dimens.radiusSmall),
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
      onPressed: () {
        setState(() {
          _selectedCategory = category;
        });
      },
    );
  }

  void _onPressFilter() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Wrap(
        children: [
          Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: ChangeNotifierProvider.value(
              value: _productListingViewModel,
              child: const SnippetFilterProductsBottomSheet(),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildProductListing(ProductListingViewModel viewModel) {
    if (viewModel.getProductsUseCase.isLoading) {
      return [SliverToBoxAdapter(child: const ProductViewShimmerWidget())];
    }
    if (viewModel.getProductsUseCase.hasError) {
      return [
        SliverToBoxAdapter(
          child: DefaultErrorWidget(
            manuallyCenter: true,
            errorMessage: viewModel.getProductsUseCase.exception!,
            onActionButtonPressed: () async {
              await getData();
            },
          ),
        )
      ];
    }
    if (viewModel.sortedProducts.isEmpty) {
      return [
        const SliverToBoxAdapter(
          child: DefaultErrorWidget(
            manuallyCenter: true,
            errorMessage: 'No products available.',
          ),
        )
      ];
    }

    // A specific category chip is selected: show a single flat grid.
    if (_selectedCategory != null) {
      final filtered = viewModel.sortedProducts
          .where((p) => p.categoryName == _selectedCategory)
          .toList();
      if (filtered.isEmpty) {
        return [
          SliverToBoxAdapter(
            child: DefaultErrorWidget(
              manuallyCenter: true,
              errorMessage: 'No products in $_selectedCategory.',
            ),
          )
        ];
      }
      return [_buildProductGridSliver(filtered)];
    }

    // "All" is selected: split into one section per category, in first-seen order.
    final categoryOrder = <String>[];
    final productsByCategory = <String, List<ProductDetail>>{};
    for (final p in viewModel.sortedProducts) {
      final key = p.categoryName ?? 'Other';
      productsByCategory.putIfAbsent(key, () {
        categoryOrder.add(key);
        return [];
      }).add(p);
    }

    return [
      for (final category in categoryOrder) ...[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimens.spacingSizeSmall,
              Dimens.spacingSizeDefault,
              Dimens.spacingSizeSmall,
              Dimens.spacingSizeSmall,
            ),
            child: Text(
              category,
              style: const TextStyle(
                fontSize: Dimens.fontSizeLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Non-sliver here: stacking multiple SliverMasonryGrids back-to-back
        // (one per category section) makes each grid mis-report its scroll
        // extent, which cuts off/glitches the scroll view. A shrink-wrapped
        // grid boxed in a SliverToBoxAdapter lays out its full height upfront
        // instead, so stacking many of them is safe.
        _buildProductGridSliver(productsByCategory[category]!,
            useSliver: false),
      ],
    ];
  }

  Widget _buildProductGridSliver(List<ProductDetail> products,
      {bool useSliver = true}) {
    final grid = SnippetProductListing(
      useSliver: useSliver,
      // Non-sliver grids are nested inside the outer CustomScrollView (one per
      // category section); without this they fight the outer view for scroll
      // gestures, which is what caused the scroll glitch/cutoff.
      physics: useSliver ? null : const NeverScrollableScrollPhysics(),
      products: products.map(Product.fromDetail).toList(),
    );
    return useSliver ? grid : SliverToBoxAdapter(child: grid);
  }
}
