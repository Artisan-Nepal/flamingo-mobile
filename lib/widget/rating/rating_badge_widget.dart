import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

// Compact "★ 4.6 (128)" chip for the PDP header and product cards. Renders
// nothing when there are no ratings yet, rather than showing "0.0 (0)".
class RatingBadgeWidget extends StatelessWidget {
  const RatingBadgeWidget({
    super.key,
    required this.averageRating,
    required this.reviewCount,
    this.fontSize = Dimens.fontSizeSmall,
  });

  final double? averageRating;
  final int? reviewCount;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    if (averageRating == null || reviewCount == null || reviewCount == 0) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: fontSize + 2, color: AppColors.warning),
        const SizedBox(width: 2),
        TextWidget(
          '${averageRating!.toStringAsFixed(1)} ($reviewCount)',
          style: textTheme(context).bodySmall!.copyWith(
                fontSize: fontSize,
                color: AppColors.grayMain,
              ),
        ),
      ],
    );
  }
}
