import 'package:flamingo/feature/advertisement/screen/advertisement_app_bar_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/fav-button/fav_vendor_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SnippetAdvertisementAppBar extends StatelessWidget {
  const SnippetAdvertisementAppBar({
    super.key,
    required this.title,
    required this.vendorId,
  });

  final String title;
  final String vendorId;

  @override
  Widget build(BuildContext context) {
    var backButtonColor = isLightMode(context) ? Colors.black : Colors.white;
    var backgroundColor = isLightMode(context) ? Colors.white : Colors.black;
    return PreferredSize(
      preferredSize: Size(SizeConfig.screenWidth, 100),
      child: SizedBox(
        height: SizeConfig.appBarHeight + SizeConfig.statusBarHeight - 20,
        child: Consumer<AdvertisementAppBarViewModel>(
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
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: AppColors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  alignment: Alignment.center,
                  child: Icon(
                    CupertinoIcons.back,
                    size: 26,
                    color: iconColor,
                  ),
                ),
              ),
              actions: [
                FavVendorButtonWidget(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.spacingSizeSmall,
                    vertical: Dimens.spacing_8,
                  ),
                  // color: Color.lerp(
                  //       Colors.transparent,
                  //       isLightMode(context) ? Colors.black : Colors.white,
                  //       (appBarViewModel.productDetailsOffset /
                  //               (SizeConfig.screenHeight / 15))
                  //           .clamp(0, 1)
                  //           .toDouble(),
                  //     ) ??
                  //     Colors.black,
                  vendorId: vendorId,
                  iconSize: Dimens.iconSizeDefault,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
