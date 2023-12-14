import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class SelectionIndicatorWidget extends StatelessWidget {
  const SelectionIndicatorWidget({
    super.key,
    required this.isSelected,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isLightMode(context) ? AppColors.black : AppColors.white,
        ),
      ),
      height: 12,
      width: 12,
      padding: const EdgeInsets.all(Dimens.spacing_2),
      child: isSelected
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLightMode(context) ? AppColors.black : AppColors.white,
              ),
            )
          : const SizedBox(),
    );
  }
}
