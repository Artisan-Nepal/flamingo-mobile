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
import 'package:flamingo/feature/product/data/model/product_filter_params.dart';
import 'package:flamingo/feature/product/screen/product-listing/multi_select_filter_sheet.dart';
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
  ProductFilterParams _filters = const ProductFilterParams();

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
    // Load the brand's filter options (categories/sizes) in the background.
    _productListingViewModel.getSellerFacets(widget.seller.id);

    if (_productListingViewModel.getProductsUseCase.hasCompleted) {
      await logActivity();
    }
  }

  // Re-fetch this brand's products with the current filters applied server-side.
  Future<void> _applyFilters() async {
    await _productListingViewModel.getSellerProducts(
      widget.seller.id,
      filters: _filters.isEmpty ? null : _filters,
    );
  }

  Future<void> _openCategoryPicker() async {
    final categories =
        _productListingViewModel.facetsUseCase.data?.dedupedCategories ?? [];
    final result = await showMultiSelectFilterSheet(
      context: context,
      title: 'Choose category',
      options: [
        for (final c in categories)
          MultiSelectOption(value: c.id, label: c.name)
      ],
      initialSelected: _filters.categoryIds.toSet(),
    );
    if (result != null) {
      setState(() {
        _filters = _filters.copyWith(categoryIds: result.toList());
      });
      await _applyFilters();
    }
  }

  Future<void> _openSizePicker() async {
    final sizes = _productListingViewModel.facetsUseCase.data?.sizes ?? [];
    final result = await showMultiSelectFilterSheet(
      context: context,
      title: 'Choose size',
      options: [for (final s in sizes) MultiSelectOption(value: s, label: s)],
      initialSelected: _filters.sizeValues.toSet(),
    );
    if (result != null) {
      setState(() {
        _filters = _filters.copyWith(sizeValues: result.toList());
      });
      await _applyFilters();
    }
  }

  Future<void> _toggleSale() async {
    setState(() {
      _filters = _filters.copyWith(onSale: !_filters.onSale);
    });
    await _applyFilters();
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
    final categoryCount = _filters.categoryIds.length;
    final sizeCount = _filters.sizeValues.length;
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding:
              const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
          children: [
            _buildFilterPill(
              label: 'Refine',
              icon: Icons.tune,
              onPressed: _onPressFilter,
            ),
            const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            _buildFilterPill(
              label: categoryCount > 0
                  ? 'Category ($categoryCount)'
                  : 'Choose category',
              icon: Icons.expand_more,
              selected: categoryCount > 0,
              onPressed: _openCategoryPicker,
            ),
            const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            _buildFilterPill(
              label: sizeCount > 0 ? 'Size ($sizeCount)' : 'Choose size',
              icon: Icons.expand_more,
              selected: sizeCount > 0,
              onPressed: _openSizePicker,
            ),
            const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            _buildFilterPill(
              label: 'Sale',
              icon: Icons.local_offer_outlined,
              selected: _filters.onSale,
              onPressed: _toggleSale,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool selected = false,
  }) {
    final fg = selected ? AppColors.white : AppColors.grayDarker;
    return ButtonWidget(
      label: label,
      height: 36,
      width: null,
      needBorder: true,
      borderColor: selected ? AppColors.grayDarker : AppColors.grayLight,
      backgroundColor:
          selected ? AppColors.grayDarker : AppColors.transparent,
      textColor: fg,
      fontWeight: FontWeight.w600,
      borderRaidus: BorderRadius.circular(Dimens.radiusSmall),
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: Dimens.iconSizeSmall, color: fg),
          const HorizontalSpaceWidget(width: Dimens.spacingSizeExtraSmall),
          Text(label,
              style: TextStyle(fontWeight: FontWeight.w600, color: fg)),
        ],
      ),
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
        SliverToBoxAdapter(
          child: DefaultErrorWidget(
            manuallyCenter: true,
            errorMessage: _filters.isEmpty
                ? 'No products available.'
                : 'No products match your filters.',
          ),
        )
      ];
    }

    // Filters applied: results are already narrowed server-side, so show a
    // single flat grid rather than the per-category sections.
    if (!_filters.isEmpty) {
      return [_buildProductGridSliver(viewModel.sortedProducts)];
    }

    // No filters: split into one section per category, in first-seen order.
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
