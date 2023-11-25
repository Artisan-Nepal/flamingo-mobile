import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductViewShimmerWidget extends StatelessWidget {
  const ProductViewShimmerWidget({
    Key? key,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.itemCount = 10,
    this.scrollController,
    this.shrinkWrap = true,
    this.spacing = Dimens.spacingSizeSmall,
  }) : super(key: key);

  final ScrollPhysics physics;
  final int itemCount;
  final ScrollController? scrollController;
  final bool shrinkWrap;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      controller: scrollController,
      physics: physics,
      crossAxisCount: 2,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      itemCount: itemCount,
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        return const ProductWidgetShimmer();
      },
    );
  }
}

class ProductWidgetShimmer extends StatelessWidget {
  const ProductWidgetShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            isLightMode(context) ? AppColors.grayLight : AppColors.grayDarker,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerWidget.rectangular(
              height: 170,
              smoothEdge: false,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spacingSizeExtraSmall,
                vertical: Dimens.spacingSizeExtraSmall,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerWidget.rectangular(
                    height: 12,
                    width: double.infinity,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ShimmerWidget.rectangular(
                    height: 12,
                    width: SizeConfig.screenWidth * 0.2,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
