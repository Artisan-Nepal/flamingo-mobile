import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SnippetFilterProductsBottomSheet extends StatefulWidget {
  const SnippetFilterProductsBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<SnippetFilterProductsBottomSheet> createState() =>
      _SnippetFilterProductsBottomSheetState();
}

class _SnippetFilterProductsBottomSheetState
    extends State<SnippetFilterProductsBottomSheet> {
  // Pending price range (rupees) held while the sheet is open; applied on tap.
  int _minPrice = 0;
  int _maxPrice = 0;
  late final double _maxBound;

  @override
  void initState() {
    super.initState();
    final products = Provider.of<ProductListingViewModel>(context, listen: false)
            .getProductsUseCase
            .data
            ?.rows ??
        [];
    _maxBound = priceUpperBoundRupees(products);
    _maxPrice = _maxBound.round();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Material(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                    _buildSectionLabel('Price range'),
                    const VerticalSpaceWidget(
                        height: Dimens.spacingSizeExtraSmall),
                    PriceRangeSelector(
                      maxBound: _maxBound,
                      initialMin: _minPrice,
                      initialMax: _maxPrice,
                      onChanged: (min, max) {
                        _minPrice = min;
                        _maxPrice = max;
                      },
                    ),
                    const VerticalSpaceWidget(
                        height: Dimens.spacingSizeDefault),
                    _buildFilterSelection(),
                    const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                    Center(
                      child: FilledButtonWidget(
                        width: double.infinity,
                        label: 'Apply',
                        onPressed: _onApplyFilter,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onApplyFilter() {
    // A range that still spans the whole track means "no price filter" - pass 0s
    // so sortProductsHelper keeps every product.
    final isFullRange = _minPrice <= 0 && _maxPrice >= _maxBound.round();
    Provider.of<ProductListingViewModel>(context, listen: false).sortProducts(
      startingPrice: isFullRange ? 0 : _minPrice.toDouble(),
      endingPrice: isFullRange ? 0 : _maxPrice.toDouble(),
    );
    Navigator.pop(context);
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: Dimens.fontSizeDefault,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildFilterSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Sort by'),
        const Row(
          children: [
            Expanded(
              child: SnippetFilterProductCheckBox(
                title: 'Newest first',
                filterType: ProductFilterType.newest,
              ),
            ),
            Expanded(
              child: SnippetFilterProductCheckBox(
                title: 'Oldest first',
                filterType: ProductFilterType.oldest,
              ),
            ),
          ],
        ),
        const Row(
          children: [
            Expanded(
              child: SnippetFilterProductCheckBox(
                title: 'Price: Low to High',
                filterType: ProductFilterType.priceAsc,
              ),
            ),
            Expanded(
              child: SnippetFilterProductCheckBox(
                title: 'Price: High to Low',
                filterType: ProductFilterType.priceDesc,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 15,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          const HorizontalSpaceWidget(
            width: Dimens.spacingSizeSmall,
          ),
          const Text(
            'Sort and Filters',
            style: TextStyle(
              fontSize: Dimens.fontSizeExtraLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Expanded(child: SizedBox()),
          IconButton(
            onPressed: () {
              Provider.of<ProductListingViewModel>(context, listen: false)
                  .restoreSortedList();
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.refresh_thin),
          ),
        ],
      ),
    );
  }
}

class SnippetFilterProductCheckBox extends StatelessWidget {
  final String title;
  final ProductFilterType filterType;

  const SnippetFilterProductCheckBox({
    Key? key,
    required this.title,
    required this.filterType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title:
          Text(title, style: const TextStyle(fontSize: Dimens.fontSizeSmall)),
      checkColor: themedPrimaryColor(context),
      activeColor: Colors.transparent,
      value: Provider.of<ProductListingViewModel>(context).selectedFilterType ==
          filterType,
      onChanged: (isChecked) {
        if (isChecked!) {
          Provider.of<ProductListingViewModel>(context, listen: false)
              .setSelectedFilterType(filterType);
        }
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
