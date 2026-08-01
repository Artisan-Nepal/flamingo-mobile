import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/vendor/screen/followed-brands/followed_brands_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

// A pure entry point, not a content module: a title and one line of copy that
// open FollowedBrandsScreen, where the actual per-brand product rows live.
//
// Deliberately shows no brands or products inline. Home already carries two
// product rails (New in, Most wanted) plus EXPLORE - a third product surface
// here would be the exact repetition this overhaul removed. Followed-brand
// arrivals are a destination the customer chooses, so home only advertises it.
//
// Styled as its own card (same muted fill/border as SnippetMeasurementsBanner,
// see snippet_measurements_banner.dart) rather than a plain section header -
// this is a doorway to a whole screen, not a rail, so it's meant to read as a
// distinct, tappable surface rather than blend into the header rhythm above it.
class SnippetHomeBrands extends StatelessWidget {
  const SnippetHomeBrands({
    super.key,
    required this.isLoading,
    required this.products,
  });

  // Still fed by the existing favourite-vendor fetch, but only to decide
  // whether the entry point is worth showing - following nothing would make
  // this a door onto an empty room.
  final bool isLoading;
  final List<ProductDetail> products;

  @override
  Widget build(BuildContext context) {
    if (isLoading || products.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.spacingSizeSmall,
        vertical: Dimens.spacingSizeDefault,
      ),
      child: GestureDetector(
        onTap: () => NavigationHelper.push(
          context,
          const FollowedBrandsScreen(),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.spacingSizeDefault,
            vertical: Dimens.spacingSizeDefault,
          ),
          decoration: BoxDecoration(
            color: AppColors.grayLighter,
            borderRadius: BorderRadius.circular(Dimens.radius_5),
            border: Border.all(color: AppColors.grayLine),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BRANDS YOU FOLLOW',
                      style: textTheme(context).bodyLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const VerticalSpaceWidget(height: Dimens.spacing_2),
                    Text(
                      'Check new arrivals from your favourite brands',
                      style: textTheme(context).bodySmall!.copyWith(
                            color: AppColors.grayMain,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.grayMain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
