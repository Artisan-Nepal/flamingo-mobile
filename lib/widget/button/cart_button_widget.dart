import 'package:flamingo/feature/cart/screen/cart-listing/cart_listing_screen.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CartButtonWidget extends StatelessWidget {
  const CartButtonWidget({super.key, this.iconColor = AppColors.black});

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final cartCount = Provider.of<CustomerActivityViewModel>(context).cartCount;
    return GestureDetector(
      onTap: () {
        NavigationHelper.push(context, const CartListingScreen());
      },
      child: SizedBox(
        height: 30,
        // width: 30,
        child: Row(
          children: [
            if (cartCount > 0) ...[
              Text(
                cartCount.toString(),
                style: TextStyle(
                  color: iconColor,
                ),
              ),
              const HorizontalSpaceWidget(width: Dimens.spacingSizeExtraSmall)
            ],
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
