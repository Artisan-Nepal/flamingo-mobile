import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/image.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    Key? key,
    required this.product,
    this.nameMaxLines = 2,
  }) : super(key: key);

  final Product product;
  final int nameMaxLines;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 1),
        decoration: BoxDecoration(
          color: isLightMode(context)
              ? AppColors.grayLighter
              : AppColors.grayDarker,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 170,
                width: double.infinity,
                child: CachedNetworkImageWidget(
                  image: product.variants[0].image.url,
                  fit: BoxFit.cover,
                  placeHolder: ImageConstants.imagePlaceholder,
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacingSizeSmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      product.vendor.storeName,
                      textOverflow: TextOverflow.ellipsis,
                      style: textTheme(context).bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    // const SizedBox(height: Dimens.spacingSizeExtraSmall),
                    TextWidget(
                      product.title,
                      maxLines: nameMaxLines,
                      textOverflow: TextOverflow.ellipsis,
                      style: textTheme(context).bodySmall!,
                    ),
                    const SizedBox(height: Dimens.spacingSizeExtraSmall),
                    TextWidget(
                      'Rs. 3,200',
                      style: textTheme(context).labelLarge!,
                    ),
                    const SizedBox(height: Dimens.spacingSizeSmall),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
