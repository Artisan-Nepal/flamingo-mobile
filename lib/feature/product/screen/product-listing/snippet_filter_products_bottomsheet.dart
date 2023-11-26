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
  final TextEditingController _firstPriceController = TextEditingController();
  final FocusNode _firstFocus = FocusNode();
  final TextEditingController _lastPriceController = TextEditingController();
  final FocusNode _lastFocus = FocusNode();

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
                    _buildPriceRange(),
                    const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
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
    double minPrice = 0.0;
    double maxPrice = 0.0;
    if (_firstPriceController.text.isNotEmpty &&
        _lastPriceController.text.isNotEmpty) {
      minPrice = double.parse(_firstPriceController.text);
      maxPrice = double.parse(_lastPriceController.text);
    }

    Provider.of<ProductListingViewModel>(context, listen: false).sortProducts(
      startingPrice: minPrice,
      endingPrice: maxPrice,
    );
    Navigator.pop(context);
  }

  Widget _buildFilterSelection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
        ),
        Row(
          children: [
            Expanded(
              child: SnippetFilterProductCheckBox(
                title: 'Low To High Price',
                filterType: ProductFilterType.priceAsc,
              ),
            ),
            Expanded(
              child: SnippetFilterProductCheckBox(
                title: 'High To Low Price',
                filterType: ProductFilterType.priceDesc,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRange() {
    return Row(
      children: [
        const Text('Price range'),
        const Expanded(child: SizedBox()),
        _buildTextInput(
          controller: _firstPriceController,
          focusNode: _firstFocus,
        ),
        const Text(' - '),
        _buildTextInput(
          controller: _lastPriceController,
          focusNode: _lastFocus,
        ),
      ],
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return SizedBox(
      height: 40,
      width: 100,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        controller: controller,
        maxLines: 1,
        focusNode: focusNode,
        textInputAction: TextInputAction.done,
        style: TypographyStyles.labelLarge,
        decoration: InputDecoration(
          filled: true,
          fillColor: themedPrimaryColor(context).withOpacity(0.2),
          contentPadding: const EdgeInsets.only(bottom: 8),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5.7),
          ),
        ),
      ),
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
