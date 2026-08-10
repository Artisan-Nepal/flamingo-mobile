import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

// Interactive 1-5 star selector for the write-review form. Tapping a star
// sets the rating to that star's position (1-indexed).
class StarRatingInput extends StatelessWidget {
  const StarRatingInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = Dimens.iconSizeExtraLarge,
    this.color = AppColors.warning,
    this.emptyColor = AppColors.grayLight,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final double size;
  final Color color;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starPosition = index + 1;
        return GestureDetector(
          onTap: () => onChanged(starPosition),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spacingSizeExtraSmall),
            child: Icon(
              starPosition <= value ? Icons.star : Icons.star_border,
              size: size,
              color: starPosition <= value ? color : emptyColor,
            ),
          ),
        );
      }),
    );
  }
}
