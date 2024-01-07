import 'package:flamingo/feature/advertisement/data/model/advertisement.dart';
import 'package:flamingo/feature/advertisement/screen/snippet_advertisement_images.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/shared/util/util.dart';
import 'package:flamingo/widget/product/product_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class AdvertisementScreen extends StatelessWidget {
  const AdvertisementScreen({
    super.key,
    required this.advertisement,
  });

  final Advertisement advertisement;

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      padding: EdgeInsets.zero,
      appBarTitle: Text(advertisement.vendor.storeName),
      child: Column(
        children: [
          // TextWidget(
          //   advertisement.vendor.storeName,
          //   style: textTheme(context).headlineSmall!.copyWith(
          //         fontWeight: FontWeight.bold,
          //       ),
          // ),
          // VerticalSpaceWidget(height: Dimens.spacingSizeDefault),

          // Advertisement image
          SnippetAdvertisementImages(
            images: advertisement.images.map((e) => e.url).toList(),
          ),

          VerticalSpaceWidget(height: Dimens.spacingSizeDefault),

          // Advertisement details and products
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  advertisement.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimens.fontSizeExtraLarge,
                  ),
                ),
                VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
                if (advertisement.description != null) ...[
                  Text(
                    advertisement.description!,
                    style: const TextStyle(
                      fontSize: Dimens.fontSizeDefault,
                    ),
                  ),
                  VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                ],
                SnippetProductListing(
                  // shrinkWrap: true,
                  products: advertisement.collection.products
                      .map(
                        (p) => GenericProduct(
                          image: p.images.firstOrNull ?? "",
                          price: p.price,
                          productId: p.id,
                          title: p.title,
                          vendor: advertisement.vendor.storeName,
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
