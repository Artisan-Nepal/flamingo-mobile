import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_app_bar_view_model.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_view_model.dart';
import 'package:flamingo/feature/product/screen/product-detail/snippet_color_selection_bottom_sheet.dart';
import 'package:flamingo/feature/product/screen/product-detail/snippet_product_detail_app_bar.dart';
import 'package:flamingo/feature/product/screen/product-detail/snippet_product_detail_images.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    this.product,
  });

  final Product? product;

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
    _viewModel.setProduct(widget.product);
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
          return DefaultScreen(
            scrollable: false,
            padding: EdgeInsets.zero,
            needAppBar: false,
            statusBarIconBrightness: Brightness.dark,
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
                            variants: viewModel.product.variants,
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
                                  data: viewModel.product.body,
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
                                  value: viewModel.selectedSize.value,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SnippetProductDetailAppBar(),
                _buildAddToBagButton(),
              ],
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

  Widget _buildAddToBagButton() {
    return Positioned(
      bottom: 0,
      right: Dimens.spacingSizeDefault,
      left: Dimens.spacingSizeDefault,
      child: FilledButtonWidget(
        label: 'Add to Bag',
        width: SizeConfig.screenWidth - 2 * Dimens.spacingSizeDefault,
      ),
    );
  }

  List<Widget> _buildProductInformation(ProductDetailViewModel viewModel) {
    return [
      TextWidget(
        viewModel.product.vendor.storeName,
        textOverflow: TextOverflow.ellipsis,
        style: textTheme(context).bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      TextWidget(
        viewModel.product.title,
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
