import 'package:flamingo/feature/product/screen/product-detail/product_detail_app_bar_view_model.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SnippetProductDetailAppBar extends StatelessWidget {
  const SnippetProductDetailAppBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    var backButtonColor = isLightMode(context) ? Colors.black : Colors.white;
    var backgroundColor = isLightMode(context) ? Colors.white : Colors.black;
    return PreferredSize(
      preferredSize: Size(SizeConfig.screenWidth, 100),
      child: SizedBox(
        height: SizeConfig.appBarHeight + SizeConfig.statusBarHeight - 20,
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
                  title,
                  style: TextStyle(
                    color: Color.lerp(
                      Colors.transparent,
                      isLightMode(context) ? Colors.black : Colors.white,
                      (appBarViewModel.productDetailsOffset /
                              (SizeConfig.screenHeight / 15))
                          .clamp(0, 1)
                          .toDouble(),
                    ),
                  ),
                ),
                backgroundColor: backgroundColor.withOpacity(
                    (appBarViewModel.productDetailsOffset /
                            (SizeConfig.screenHeight / 15))
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
                actions: const [
                  // Shopping bag
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.spacingSizeDefault,
                      vertical: Dimens.spacing_8,
                    ),
                    child: CartButtonWidget(),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
