import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({
    super.key,
    required this.child,
    this.appBarTitle,
    this.appBarActions,
    this.needAppBar = true,
    this.bottomNavigationBar,
    this.padding =
        const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
    this.appBarLeading,
    this.automaticallyImplyAppBarLeading = true,
    this.scrollable = true,
    this.bottomBarPadding = const EdgeInsets.all(Dimens.spacingSizeDefault),
    this.statusBarIconBrightness,
    this.scrollController,
    this.bottomNavBarWithButton = false,
    this.bottomNavBarWithButtonLabel,
    this.bottomNavBarWithButtonOnPressed,
    this.isLoading = false,
    this.onRefresh,
  });

  final Widget child;
  final Widget? appBarTitle;
  final List<Widget>? appBarActions;
  final Widget? appBarLeading;
  final bool needAppBar;
  final Widget? bottomNavigationBar;
  final EdgeInsets padding;
  final EdgeInsets bottomBarPadding;
  final bool automaticallyImplyAppBarLeading;
  final bool scrollable;
  final Brightness? statusBarIconBrightness;
  final bool bottomNavBarWithButton;
  final ScrollController? scrollController;
  final String? bottomNavBarWithButtonLabel;
  final VoidCallback? bottomNavBarWithButtonOnPressed;
  final bool isLoading;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: statusBarIconBrightness ??
            (isLightMode(context) ? Brightness.dark : Brightness.light),
      ),
      child: Scaffold(
        appBar: needAppBar
            ? AppBar(
                title: appBarTitle,
                actions: appBarActions,
                leading: appBarLeading ??
                    (NavigationHelper.canPop(context) &&
                            automaticallyImplyAppBarLeading
                        ? GestureDetector(
                            onTap: () {
                              NavigationHelper.pop(context);
                            },
                            child: const Icon(
                              CupertinoIcons.back,
                              size: Dimens.iconSizeLarge,
                            ),
                          )
                        : null),
                automaticallyImplyLeading: automaticallyImplyAppBarLeading,
              )
            : null,
        body: _buildBody(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(Dimens.spacingSizeDefault),
          child: bottomNavBarWithButton
              ? FilledButtonWidget(
                  label: bottomNavBarWithButtonLabel ?? "",
                  onPressed: bottomNavBarWithButtonOnPressed,
                  isLoading: isLoading,
                )
              : bottomNavigationBar,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return false;
      },
      child: GestureDetector(
        child: scrollable
            ? SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              )
            : Padding(
                padding: padding,
                child: child,
              ),
      ),
    );
  }
}
