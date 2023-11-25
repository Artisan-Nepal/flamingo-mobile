import 'package:flamingo/feature/product/screen/product-detail/product_detail_app_bar_view_model.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SnippetProductDetailAppBar extends StatelessWidget {
  const SnippetProductDetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var backButtonColor = isLightMode(context) ? Colors.black : Colors.white;
    var backgroundColor = isLightMode(context) ? Colors.white : Colors.black;
    return PreferredSize(
      preferredSize: Size(SizeConfig.screenWidth, 100),
      child: SizedBox(
        height: 56 + SizeConfig.statusBarHeight,
        child: Consumer<ProductDetailViewModel>(
          builder: (context, productDetailViewModel, child) =>
              Consumer<ProductDetailAppBarViewModel>(
            builder: (context, appBarViewModel, child) {
              final iconColor = Color.lerp(
                Colors.black,
                backButtonColor,
                (appBarViewModel.productDetailsOffset /
                        (SizeConfig.screenHeight / 5))
                    .clamp(0, 1)
                    .toDouble(),
              );
              return AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark),
                title: Text(
                  productDetailViewModel.product.title,
                  style: TextStyle(
                    color: Color.lerp(
                      Colors.transparent,
                      isLightMode(context) ? Colors.black : Colors.white,
                      (appBarViewModel.productDetailsOffset /
                              (SizeConfig.screenHeight / 5))
                          .clamp(0, 1)
                          .toDouble(),
                    ),
                  ),
                ),
                backgroundColor: backgroundColor.withOpacity(
                    (appBarViewModel.productDetailsOffset /
                            (SizeConfig.screenHeight / 5))
                        .clamp(0, 1)
                        .toDouble()),
                elevation: 0,
                leadingWidth: 38,
                // back Button
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      alignment: Alignment.center,
                      child: Icon(
                        CupertinoIcons.back,
                        size: 26,
                        color: iconColor,
                      ),
                    ),
                  ),
                ),
                actions: [
                  // Shopping bag
                  GestureDetector(
                    onTap: () {
                      // Provider.of<AuthProvider>(context, listen: false).isLoggedIn
                      //     ? Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const CartScreen()))
                      //     : showJoinAndConnectWidget(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Dimens.spacingSizeSmall),
                      height: 30,
                      // width: 30,
                      margin: const EdgeInsets.symmetric(
                        horizontal: Dimens.spacingSizeSmall,
                        vertical: Dimens.spacing_8,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '2',
                            style: TextStyle(
                              color: iconColor,
                            ),
                          ),
                          const HorizontalSpaceWidget(
                              width: Dimens.spacingSizeExtraSmall),
                          Icon(
                            CupertinoIcons.bag,
                            size: 22,
                            color: iconColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
