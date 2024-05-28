import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/advertisement/data/model/advertisement.dart';
import 'package:flamingo/feature/advertisement/screen/advertisement_app_bar_view_model.dart';
import 'package:flamingo/feature/advertisement/screen/snippet_advertisement_app_bar.dart';
import 'package:flamingo/feature/advertisement/screen/snippet_advertisement_images.dart';
import 'package:flamingo/feature/customer-activity/create_activity_view_model.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/shared/constant/advertisement_activity_type.dart';
import 'package:flamingo/shared/enum/lead_source.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/shared/util/util.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdvertisementScreen extends StatefulWidget {
  const AdvertisementScreen({
    super.key,
    required this.advertisement,
  });

  final Advertisement advertisement;

  @override
  State<AdvertisementScreen> createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  final _appBarViewModel = locator<AdvertisementAppBarViewModel>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    logActivity();
    _scrollController.addListener(() {
      _appBarViewModel.setScrollOffset(_scrollController.offset);
    });
  }

  logActivity() async {
    await locator<CreateActivityViewModel>().createAdvertisementActivity(
      advertisementId: widget.advertisement.id,
      activityType: AdvertisementActivityType.click,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _appBarViewModel,
      child: DefaultScreen(
        padding: EdgeInsets.zero,
        needAppBar: false,
        scrollable: false,
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Advertisement image
                      SnippetAdvertisementImages(
                        images: widget.advertisement.images
                            .map((e) => e.url)
                            .toList(),
                        primaryVideo: widget.advertisement.primaryVideoUrl,
                      ),

                      VerticalSpaceWidget(height: Dimens.spacingSizeDefault),

                      // Advertisement details and products
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.spacingSizeDefault),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.advertisement.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimens.fontSizeExtraLarge,
                                ),
                              ),
                              VerticalSpaceWidget(
                                  height: Dimens.spacingSizeExtraSmall),
                              if (widget.advertisement.description != null) ...[
                                Text(
                                  widget.advertisement.description!,
                                  style: const TextStyle(
                                    fontSize: Dimens.fontSizeDefault,
                                  ),
                                ),
                                VerticalSpaceWidget(
                                    height: Dimens.spacingSizeDefault),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SnippetProductListing(
                  useSliver: true,
                  padding: 0,
                  advertisementId: widget.advertisement.id,
                  leadSource: LeadSource.advertisement,
                  products: widget.advertisement.collection.products
                      .map(
                        (p) => Product(
                          quantity: p.variants.first.quantityInStock,
                          image: extractProductDefaultImage(
                            p.images,
                            p.variants,
                          ),
                          price: p.variants.first.price,
                          productId: p.id,
                          title: p.title,
                          sellerStoreName:
                              widget.advertisement.vendor.seller.storeName,
                        ),
                      )
                      .toList(),
                )
              ],
            ),
            SnippetAdvertisementAppBar(
              title: widget.advertisement.vendor.seller.storeName,
              vendorId: widget.advertisement.vendorId,
            ),
          ],
        ),
      ),
    );
  }
}
