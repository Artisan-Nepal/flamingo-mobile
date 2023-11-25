import 'package:flamingo/feature/product/data/model/product_color.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SnippetColorSelectionBottomSheet extends StatefulWidget {
  const SnippetColorSelectionBottomSheet({super.key});

  @override
  State<SnippetColorSelectionBottomSheet> createState() =>
      _SnippetColorSelectionBottomSheetState();
}

class _SnippetColorSelectionBottomSheetState
    extends State<SnippetColorSelectionBottomSheet> {
  late ProductColor _selectedColor;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final viewModel =
        Provider.of<ProductDetailViewModel>(context, listen: false);
    _selectedColor = viewModel.selectedColor;
    _scrollController = FixedExtentScrollController(
      initialItem: viewModel.availableColors.indexOf(viewModel.selectedColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.spacingSizeSmall),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    NavigationHelper.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              TextWidget(
                'Select Color',
                style: textTheme(context).bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
              _buildSelector(),
              const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
              FilledButtonWidget(
                label: 'Select',
                width: double.infinity,
                onPressed: () {
                  Provider.of<ProductDetailViewModel>(context, listen: false)
                      .setSelectedColor(_selectedColor);
                  NavigationHelper.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelector() {
    return Consumer<ProductDetailViewModel>(
      builder: (context, viewModel, child) {
        return SizedBox(
          height: 100,
          child: CupertinoPicker(
            scrollController: _scrollController,
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              _selectedColor = viewModel.availableColors[index];
            },
            selectionOverlay: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.grayLight, width: 0.5),
                  top: BorderSide(color: AppColors.grayLight, width: 0.5),
                ),
              ),
            ),
            children: List<Widget>.generate(
              viewModel.availableColors.length,
              (index) {
                final productVariant = viewModel.getVariantByColorAndSize(
                    viewModel.availableColors[index], viewModel.selectedSize);
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Rs. ${formatNepaliCurrency(productVariant.price)}',
                        style: textTheme(context).labelLarge,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        viewModel.availableColors[index].name,
                        textAlign: TextAlign.center,
                        style: textTheme(context).labelLarge,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        productVariant.quantityInStock > 0
                            ? 'Last ${productVariant.quantityInStock} left'
                            : 'Out of Stock',
                        textAlign: TextAlign.end,
                        style: textTheme(context).labelLarge,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
