import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

// Read-only star row rendered from a 0-5 double, e.g. a review's rating or a
// product's average. Renders half stars when [value] isn't a whole number.
class StarRatingWidget extends StatelessWidget {
  const StarRatingWidget({
    super.key,
    required this.value,
    this.size = Dimens.iconSizeSmall,
    this.color = AppColors.warning,
    this.emptyColor = AppColors.grayLight,
  });

  final double value;
  final double size;
  final Color color;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = value - index;
        IconData icon;
        if (starValue >= 1) {
          icon = Icons.star;
        } else if (starValue >= 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(
          icon,
          size: size,
          color: starValue > 0 ? color : emptyColor,
        );
      }),
    );
  }
}
