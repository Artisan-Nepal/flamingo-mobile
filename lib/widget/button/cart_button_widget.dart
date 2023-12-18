import 'package:flamingo/feature/cart/screen/cart-listing/cart_listing_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';

class CartButtonWidget extends StatelessWidget {
  const CartButtonWidget({super.key, this.iconColor = AppColors.black});

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationHelper.push(context, const CartListingScreen());
      },
      child: SizedBox(
        height: 30,
        // width: 30,
        child: Row(
          children: [
            Text(
              '2',
              style: TextStyle(
                color: iconColor,
              ),
            ),
            const HorizontalSpaceWidget(width: Dimens.spacingSizeExtraSmall),
            Icon(
              CupertinoIcons.bag,
              size: 22,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
