import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/auth/screen/login/login_screen.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_app_bar_view_model.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_view_model.dart';
import 'package:flamingo/feature/product/screen/product-detail/snippet_add_to_cart_summary_bottom_sheet.dart';
import 'package:flamingo/feature/product/screen/product-detail/snippet_color_selection_bottom_sheet.dart';
import 'package:flamingo/feature/product/screen/product-detail/snippet_product_detail_app_bar.dart';
import 'package:flamingo/feature/product/screen/product-detail/snippet_product_detail_images.dart';
import 'package:flamingo/feature/product/screen/product-detail/snippet_size_selection_bottom_sheet.dart';
import 'package:flamingo/feature/product/screen/product-listing/min_product_listing_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/shared/enum/lead_source.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/list-tile/list_tile.dart';
import 'package:flamingo/widget/loader/default_screen_loader_widget.dart';
import 'package:flamingo/widget/loader/full_screen_loader.dart';
import 'package:flamingo/widget/shimmer/shimmer.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    this.product,
    required this.productId,
    required this.title,
    this.leadSource,
    this.advertisementId,
    this.readOnly = false,
  });

  final ProductDetail? product;
  final String productId;
  final String title;
  final LeadSource? leadSource;
  final String? advertisementId;

  // When opened from the shopping bag or an order, the product is shown for
  // reference only: no add-to-bag, no colour/size selectors, and no
  // recommendations - just a back button to return where you came from.
  final bool readOnly;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _scrollController = ScrollController();
  late PageController _productImagePageController;

  final _viewModel = locator<ProductDetailViewModel>();
  final _appBarViewModel = locator<ProductDetailAppBarViewModel>();
  final _relatedProductsViewModel = locator<MinProductListingViewModel>();
  final _inStockAlternativesViewModel = locator<MinProductListingViewModel>();

  @override
  void initState() {
    super.initState();
    _productImagePageController = PageController(viewportFraction: 0.99999999);

    _viewModel.setProduct(widget.productId, widget.product,
        leadSource: widget.leadSource, advertisementId: widget.advertisementId);
    _appBarViewModel.init();
    _scrollController.addListener(() {
      _appBarViewModel.setScrollOffset(_scrollController.offset);
    });

    // Recommendations/alternatives aren't shown in read-only mode, so skip the
    // fetches entirely.
    if (!widget.readOnly) {
      _relatedProductsViewModel.getRelatedProducts(widget.productId);
      // The recommender resolves alternatives at the product level (based on
      // its primary image), so one fetch here covers every variant - whether
      // it's shown just depends on which variant is selected at render time.
      _inStockAlternativesViewModel.getInStockAlternatives(widget.productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _appBarViewModel,
        ),
        ChangeNotifierProvider(
          create: (context) => _viewModel,
        ),
        ChangeNotifierProvider(
          create: (context) => _relatedProductsViewModel,
        ),
        // _inStockAlternativesViewModel is intentionally NOT registered here:
        // it's the same type as _relatedProductsViewModel, and a second
        // top-level provider of that type would shadow the first for every
        // Provider.of<MinProductListingViewModel> call in this subtree
        // (including the existing related-products section below). It's
        // scoped locally instead, right where it's rendered.
      ],
      child: Consumer<ProductDetailViewModel>(
        builder: (context, viewModel, child) {
          return Builder(builder: (context) {
            return DefaultScreen(
              scrollable: false,
              padding: EdgeInsets.zero,
              needAppBar: false,
              statusBarIconBrightness: Brightness.dark,
              child: viewModel.productUseCase.isLoading
                  ? const DefaultScreenLoaderWidget()
                  : viewModel.productUseCase.hasError
                      ? DefaultErrorWidget(
                          errorMessage: viewModel.productUseCase.exception!,
                        )
                      : Stack(
                          children: [
                            // Keeps the hero image (and everything below it)
                            // starting below the status bar/notch instead of
                            // bleeding behind it - the floating app bar below
                            // is a separate Stack sibling that already accounts
                            // for the status bar height itself, so it's left
                            // out of this SafeArea to avoid double-padding it.
                            SafeArea(
                              bottom: false,
                              child: CustomScrollView(
                                controller: _scrollController,
                                slivers: [
                                  SliverToBoxAdapter(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SnippetProductDetailImages(
                                          pageController:
                                              _productImagePageController,
                                          seller: viewModel
                                              .productUseCase.data!.seller,
                                          title: viewModel
                                              .productUseCase.data!.title,
                                          stories: viewModel
                                              .productUseCase.data!.stories,
                                          productId:
                                              viewModel.productUseCase.data!.id,
                                          images: getDetailImages(
                                              viewModel.productUseCase.data!),
                                          advertisementId:
                                              widget.advertisementId,
                                          leadSource: widget.leadSource,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimens.spacingSizeDefault),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const VerticalSpaceWidget(
                                                  height: Dimens
                                                      .spacingSizeDefault),

                                              // Product information
                                              ..._buildProductInformation(
                                                  viewModel),
                                              const VerticalSpaceWidget(
                                                  height: Dimens
                                                      .spacingSizeDefault),

                                              const VerticalSpaceWidget(
                                                  height:
                                                      Dimens.spacingSizeSmall),

                                              // Colour/size: interactive
                                              // selectors normally; in read-only
                                              // mode they are shown as plain
                                              // reference info (no tap, no
                                              // chevron).
                                              // Color
                                              _buildAttributeSelection(
                                                name: 'Color',
                                                value:
                                                    viewModel.selectedColor.name,
                                                readOnly: widget.readOnly,
                                                onPressed: () {
                                                  showCupertinoModalPopup(
                                                    context: context,
                                                    builder: (context) => Wrap(
                                                      children: [
                                                        ChangeNotifierProvider
                                                            .value(
                                                          value: _viewModel,
                                                          child:
                                                              SnippetColorSelectionBottomSheet(
                                                            productImagePageController:
                                                                _productImagePageController,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                  height: Dimens
                                                      .spacingSizeDefault),

                                              // Size
                                              _buildAttributeSelection(
                                                name: 'Size',
                                                value: viewModel
                                                    .selectedSizeOption.value,
                                                readOnly: widget.readOnly,
                                                onPressed: () {
                                                  showCupertinoModalPopup(
                                                    context: context,
                                                    builder: (context) => Wrap(
                                                      children: [
                                                        ChangeNotifierProvider
                                                            .value(
                                                          value: _viewModel,
                                                          child:
                                                              const SnippetSizeSelectionBottomSheet(),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                  height: Dimens
                                                      .spacingSizeDefault),

                                              if (!widget.readOnly &&
                                                  viewModel.selectedVariant
                                                          .quantityInStock ==
                                                      0) ...[
                                                _buildOutOfStockAlternatives(),
                                                const SizedBox(
                                                    height: Dimens
                                                        .spacingSizeDefault),
                                              ],

                                              ..._buildExpansionTiles(
                                                  viewModel),
                                              VerticalSpaceWidget(
                                                  height: Dimens
                                                      .spacingSizeDefault),
                                              _buildContactUs(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: const SizedBox(
                                        height: Dimens.spacing_30),
                                  ),
                                  // "Recommended for you" is hidden in
                                  // read-only mode.
                                  if (!widget.readOnly) ...[
                                    _buildRelatedProductsHeader(context),
                                    _buildRelatedProducts(context),
                                  ],
                                  SliverToBoxAdapter(
                                    child: const SizedBox(
                                      height: Dimens.spacing_64,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SnippetProductDetailAppBar(
                              title: widget.title,
                              showCartAction: !widget.readOnly,
                            ),
                            if (!widget.readOnly)
                              _buildAddToBagButton(viewModel),
                          ],
                        ),
            );
          });
        },
      ),
    );
  }

  Widget _buildRelatedProductsHeader(BuildContext context) {
    final viewModel = Provider.of<MinProductListingViewModel>(context);
    final products = viewModel.getProductsUseCase.data ?? [];
    if (viewModel.getProductsUseCase.hasCompleted && products.isNotEmpty)
      return SliverToBoxAdapter(
          child: Padding(
        padding: const EdgeInsets.only(
          left: Dimens.spacingSizeDefault,
          bottom: Dimens.spacingSizeLarge,
        ),
        child: Text(
          'Recommended for you',
          style: textTheme(context).bodyLarge,
        ),
      ));
    return SliverToBoxAdapter(child: const SizedBox());
  }

  Widget _buildRelatedProducts(BuildContext context) {
    final viewModel = Provider.of<MinProductListingViewModel>(context);
    if (viewModel.getProductsUseCase.isLoading)
      return SliverToBoxAdapter(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
          child: const ProductViewShimmerWidget(
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
      );
    final products = viewModel.getProductsUseCase.data ?? [];
    if (viewModel.getProductsUseCase.hasCompleted && products.isNotEmpty) {
      return SnippetProductListing(
        useSliver: true,
        needFavIcon: false,
        products: products,
        shrinkWrap: false,
      );
    }
    return SliverToBoxAdapter(child: const SizedBox());
  }

  // Scoped locally (ChangeNotifierProvider.value) rather than registered
  // alongside _relatedProductsViewModel above - both are the same
  // MinProductListingViewModel type, and a second top-level provider of that
  // type would shadow the first for every Provider.of call in this subtree.
  Widget _buildOutOfStockAlternatives() {
    return ChangeNotifierProvider.value(
      value: _inStockAlternativesViewModel,
      child: Consumer<MinProductListingViewModel>(
        builder: (context, viewModel, child) {
          final products = viewModel.getProductsUseCase.data ?? [];
          if (!viewModel.getProductsUseCase.hasCompleted || products.isEmpty) {
            return const SizedBox();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Out of stock - try these instead',
                style: textTheme(context).bodyLarge,
              ),
              const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
              SnippetProductListing(
                needFavIcon: false,
                products: products,
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildExpansionTiles(ProductDetailViewModel viewModel) {
    final product = viewModel.productUseCase.data!;
    return [
      ExpansionTileWidget(
        initiallyExpanded: true,
        title: Text(
          'THE DETAILS',
          style: textTheme(context).bodyMedium,
        ),
        children: <Widget>[
          Text(
            'Description',
            style: TextStyle(
              color: AppColors.grayMain,
            ),
          ),
          VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
          Text(viewModel.productUseCase.data!.body,
              style: textTheme(context).bodyMedium!),
          if (viewModel.productUseCase.data!.details != null) ...[
            VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
            Text(
              'Highlights',
              style: TextStyle(
                color: AppColors.grayMain,
              ),
            ),
            Html(
              data: product.details,
            ),
          ]
        ],
      ),
      Divider(
        color: AppColors.grayLight,
      ),
      if (product.seller.storeDescription != null &&
          product.seller.storeDescription!.isNotEmpty) ...[
        ExpansionTileWidget(
          title: Text(
            'ABOUT THE BRAND',
            style: textTheme(context).bodyMedium,
          ),
          children: <Widget>[
            Text(
              product.seller.storeDescription!,
              style: textTheme(context).bodyMedium,
            ),
          ],
        ),
        Divider(
          color: AppColors.grayLight,
        ),
      ]
    ];
  }

  Widget _buildContactUs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONTACT US',
          style: textTheme(context).bodyMedium,
        ),
        VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
        Text('Available Sunday to Friday 9am - 5pm'),
        VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
        Row(
          children: [
            Expanded(
              child: OutlinedButtonWidget(
                height: 40,
                label: 'Phone',
                onPressed: () async {
                  final url = 'tel:${CommonConstants.contactNumber}';
                  UrlLauncherHelper.launch(url);
                },
              ),
            ),
            HorizontalSpaceWidget(width: Dimens.spacingSizeDefault),
            Expanded(
              child: OutlinedButtonWidget(
                height: 40,
                label: 'Email Us',
                onPressed: () {
                  final url = 'mailto:${CommonConstants.contactEmail}';
                  UrlLauncherHelper.launch(url);
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildAttributeSelection({
    required String name,
    required String value,
    VoidCallback? onPressed,
    bool readOnly = false,
  }) {
    return GestureDetector(
      onTap: readOnly ? null : onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isLightMode(context) ? AppColors.black : AppColors.white,
          ),
          borderRadius: BorderRadius.circular(
            Dimens.radiusSmall,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacingSizeDefault,
          vertical: Dimens.spacingSizeSmall,
        ),
        width: double.infinity,
        child: Row(
          children: [
            Text('$name: '),
            Text(
              value,
              style: textTheme(context)
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const Expanded(child: SizedBox()),
            // The chevron signals "tap to change" - omitted in read-only mode.
            if (!readOnly)
              const Icon(
                CupertinoIcons.chevron_down,
                size: Dimens.iconSizeSmall,
              )
          ],
        ),
      ),
    );
  }

  Widget _buildAddToBagButton(ProductDetailViewModel viewModel) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Positioned(
      bottom: 0,
      right: Dimens.spacingSizeDefault,
      left: Dimens.spacingSizeDefault,
      child: FilledButtonWidget(
        label: 'Add to Bag',
        width: SizeConfig.screenWidth - 2 * Dimens.spacingSizeDefault,
        onPressed: () async {
          if (!authViewModel.isLoggedIn) {
            NavigationHelper.push(
              context,
              LoginScreen(
                needContinueAsGuest: false,
              ),
            );
            return;
          }
          showFullScreenLoader(context);
          await viewModel.addToCart(
            leadSource: widget.leadSource,
            advertisementId: widget.advertisementId,
          );
          _observeAddToCartResponse(viewModel);
        },
      ),
    );
  }

  void _observeAddToCartResponse(ProductDetailViewModel viewModel) {
    NavigationHelper.pop(context);

    if (viewModel.addToCartUseCase.hasCompleted) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => Wrap(
          children: [
            ChangeNotifierProvider.value(
              value: _viewModel,
              child: const SnippetAddToCartSummaryBottomSheet(),
            )
          ],
        ),
      );
    } else {
      showToast(
        context,
        message: viewModel.addToCartUseCase.exception,
        isSuccess: false,
      );
    }
  }

  List<Widget> _buildProductInformation(ProductDetailViewModel viewModel) {
    return [
      TextWidget(
        viewModel.productUseCase.data!.seller.storeName,
        textOverflow: TextOverflow.ellipsis,
        style: textTheme(context).bodyMedium!.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
      TextWidget(
        viewModel.productUseCase.data!.title,
        textOverflow: TextOverflow.ellipsis,
        style: textTheme(context).bodyMedium!,
      ),
      Row(
        children: [
          TextWidget(
            'Rs. ${formatNepaliCurrency(viewModel.selectedVariant.effectivePrice)}',
            style: textTheme(context).labelLarge!,
          ),
          if (viewModel.selectedVariant.originalPrice != null) ...[
            const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            TextWidget(
              'Rs. ${formatNepaliCurrency(viewModel.selectedVariant.originalPrice!)}',
              style: textTheme(context).labelLarge!.copyWith(
                    color: AppColors.grayMain,
                    decoration: TextDecoration.lineThrough,
                  ),
            ),
          ],
        ],
      ),
    ];
  }
}
