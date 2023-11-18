import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flutter/material.dart';

void bottomSlider(BuildContext context, Widget widget) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        color: AppColors.white,
        height: MediaQuery.of(context).size.height *
            0.4, // Set to 40% of screen height
        child: Column(
          children: [
            const VerticalSpaceWidget(height: 5),
            Container(
              height: 7,
              width: MediaQuery.of(context).size.width * .13,
              decoration: BoxDecoration(
                  color: AppColors.grayMain,
                  border: Border.all(color: AppColors.grayMain),
                  borderRadius: BorderRadius.circular(4)),
            ),
            Expanded(
              child: widget,
            ),
          ],
        ),
      );
    },
  );
}
