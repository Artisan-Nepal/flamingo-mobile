import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_app_bar_view_model.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_view_model.dart';
import 'package:flamingo/feature/product/screen/product-detail/snippet_add_to_cart_summary_bottom_sheet.dart';
import 'package:flamingo/feature/product/screen/product-detail/snippet_color_selection_bottom_sheet.dart';
import 'package:flamingo/feature/product/screen/product-detail/snippet_product_detail_app_bar.dart';
import 'package:flamingo/feature/product/screen/product-detail/snippet_product_detail_images.dart';
import 'package:flamingo/feature/product/screen/product-detail/snippet_size_selection_bottom_sheet.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/loader/full_screen_loader.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    this.product,
    required this.productId,
    required this.title,
  });

  final Product? product;
  final String productId;
  final String title;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _scrollController = ScrollController();

  final _viewModel = locator<ProductDetailViewModel>();
  final _appBarViewModel = locator<ProductDetailAppBarViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.setProduct(widget.productId, widget.product);
    _appBarViewModel.init();
    _scrollController.addListener(() {
      _appBarViewModel.setScrollOffset(_scrollController.offset);
    });
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
      ],
      child: Consumer<ProductDetailViewModel>(
        builder: (context, viewModel, child) {
          final images = [...viewModel.productUseCase.data!.images];
          images.addAll(
              viewModel.productUseCase.data!.variants.map((e) => e.image.url));
          return DefaultScreen(
            scrollable: false,
            padding: EdgeInsets.zero,
            needAppBar: false,
            statusBarIconBrightness: Brightness.dark,
            child: SafeArea(
              child: Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SnippetProductDetailImages(
                              productId: viewModel.productUseCase.data!.id,
                              images: images,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.spacingSizeDefault),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const VerticalSpaceWidget(
                                      height: Dimens.spacingSizeDefault),
                                  ..._buildProductInformation(viewModel),
                                  const VerticalSpaceWidget(
                                      height: Dimens.spacingSizeDefault),
                                  Html(
                                    data: viewModel.productUseCase.data!.body,
                                  ),
                                  const VerticalSpaceWidget(
                                      height: Dimens.spacingSizeDefault),
                                  _buildAttributeSelection(
                                    name: 'Color',
                                    value: viewModel.selectedColor.name,
                                    onPressed: () {
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) => Wrap(
                                          children: [
                                            ChangeNotifierProvider.value(
                                              value: _viewModel,
                                              child:
                                                  const SnippetColorSelectionBottomSheet(),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                      height: Dimens.spacingSizeDefault),
                                  _buildAttributeSelection(
                                    name: 'Size',
                                    value: viewModel.selectedSizeOption.value,
                                    onPressed: () {
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) => Wrap(
                                          children: [
                                            ChangeNotifierProvider.value(
                                              value: _viewModel,
                                              child:
                                                  const SnippetSizeSelectionBottomSheet(),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SnippetProductDetailAppBar(
                    title: widget.title,
                  ),
                  _buildAddToBagButton(viewModel),
                ],
              ),
            ),
          );
        },
      ),
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
    return Positioned(
      bottom: 0,
      right: Dimens.spacingSizeDefault,
      left: Dimens.spacingSizeDefault,
      child: FilledButtonWidget(
        label: 'Add to Bag',
        width: SizeConfig.screenWidth - 2 * Dimens.spacingSizeDefault,
        onPressed: () async {
          showFullScreenLoader(context);
          await viewModel.addToCart();
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
        viewModel.productUseCase.data!.vendor.storeName,
        textOverflow: TextOverflow.ellipsis,
        style: textTheme(context).bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      TextWidget(
        viewModel.productUseCase.data!.title,
        textOverflow: TextOverflow.ellipsis,
        style: textTheme(context).bodyMedium!,
      ),
      const SizedBox(height: Dimens.spacingSizeExtraSmall),
      TextWidget(
        'Rs. ${formatNepaliCurrency(viewModel.selectedVariant.price)}',
        style: textTheme(context).labelLarge!,
      ),
    ];
  }
}
