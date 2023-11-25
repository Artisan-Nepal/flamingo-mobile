import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

class CartListingScreen extends StatelessWidget {
  const CartListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultScreen(
      needAppBar: false,
      child: SafeArea(
        child: Column(
          children: [
            VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
            ScreenTitleWidget(
              'SHOPPING BAG (2)',
            ),
          ],
        ),
      ),
    );
  }
}
