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
  });

  final ProductDetail? product;
  final String productId;
  final String title;
  final LeadSource? leadSource;
  final String? advertisementId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _scrollController = ScrollController();
  late PageController _productImagePageController;

  final _viewModel = locator<ProductDetailViewModel>();
  final _appBarViewModel = locator<ProductDetailAppBarViewModel>();
  final _relatedProductsViewModel = locator<MinProductListingViewModel>();

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

    _relatedProductsViewModel.getRelatedProducts(widget.productId);
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
                            CustomScrollView(
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
                                        advertisementId: widget.advertisementId,
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
                                                height:
                                                    Dimens.spacingSizeDefault),

                                            // Product information
                                            ..._buildProductInformation(
                                                viewModel),
                                            const VerticalSpaceWidget(
                                                height:
                                                    Dimens.spacingSizeDefault),

                                            const VerticalSpaceWidget(
                                                height:
                                                    Dimens.spacingSizeSmall),

                                            // Color
                                            _buildAttributeSelection(
                                              name: 'Color',
                                              value:
                                                  viewModel.selectedColor.name,
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
                                                height:
                                                    Dimens.spacingSizeDefault),

                                            // Size
                                            _buildAttributeSelection(
                                              name: 'Size',
                                              value: viewModel
                                                  .selectedSizeOption.value,
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
                                                height:
                                                    Dimens.spacingSizeDefault),

                                            ..._buildExpansionTiles(viewModel),
                                            VerticalSpaceWidget(
                                                height:
                                                    Dimens.spacingSizeDefault),
                                            _buildContactUs(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child:
                                      const SizedBox(height: Dimens.spacing_30),
                                ),
                                _buildRelatedProductsHeader(context),
                                _buildRelatedProducts(context),
                                SliverToBoxAdapter(
                                  child: const SizedBox(
                                    height: Dimens.spacing_64,
                                  ),
                                )
                              ],
                            ),
                            SnippetProductDetailAppBar(
                              title: widget.title,
                            ),
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
  }) {
    return GestureDetector(
      onTap: onPressed,
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
      TextWidget(
        'Rs. ${formatNepaliCurrency(viewModel.selectedVariant.price)}',
        style: textTheme(context).labelLarge!,
      ),
    ];
  }
}
