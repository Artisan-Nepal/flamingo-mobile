import 'package:flamingo/feature/dashboard/screen/home/snippet_home_products.dart';
import 'package:flamingo/feature/product/data/model/for_you_section.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-listing/for_you_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/product/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Replaces the old "FOR YOU" wrapper (a header followed by up to 5 near-
// identical product rails - one per category, see HOME_SCREEN_OVERHAUL_PLAN.md
// §1.1 for why that read as repetitive filler rather than personalization).
//
// A plain horizontal rail from the single top category - the category the
// backend ranked highest for this user (see ProductDao.findTopCategoryIdsForUser)
// - same card size/shape as every other home rail (Most wanted, New in),
// then "See More" for the rest of that category.
//
// Two earlier layouts were tried and reverted here (2026-07-27): a "Keep
// exploring" grid appended after this section, and - before that - 3 stacked
// asymmetric 60/40 pairs. The asymmetric pair squished the narrower (40%)
// card's image into the same fixed height as the wider one, distorting it;
// a plain rail has no such asymmetry to distort.
//
// Title is static, not the category name - a long category name (e.g.
// "CASUAL WEAR") embedded in the header truncated to an unhelpful "...".
class SnippetHomeForYou extends StatelessWidget {
  const SnippetHomeForYou({super.key});

  // Matches the display cap used by the other home rails (Trending, New in).
  static const int _maxDisplayed = 10;

  @override
  Widget build(BuildContext context) {
    return Consumer<ForYouViewModel>(
      builder: (context, viewModel, child) {
        final sections = viewModel.getForYouUseCase.data ?? <ForYouSection>[];
        if (!viewModel.getForYouUseCase.hasCompleted || sections.isEmpty) {
          return const SizedBox();
        }

        final topSection = sections.first;
        final products = topSection.products.take(_maxDisplayed).toList();
        if (products.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SnippetHomeScreenTitle(
              title: 'PICKED FOR YOU',
              onTap: () => NavigationHelper.push(
                context,
                ProductListingScreen(
                  title: topSection.categoryName,
                  productType: ProductType.CATEGORY,
                  categoryId: topSection.categoryId,
                ),
              ),
            ),
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight * 0.47,
              margin: const EdgeInsets.symmetric(vertical: Dimens.spacingSizeSmall),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(
                    right: Dimens.spacingSizeDefault,
                    left: index == 0 ? Dimens.spacingSizeSmall : 0,
                  ),
                  width: SizeConfig.screenWidth * 0.6,
                  child: ProductWidget(
                    imageHeight: SizeConfig.screenHeight * 0.35,
                    nameMaxLines: 1,
                    payload: Product.fromDetail(products[index]),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
