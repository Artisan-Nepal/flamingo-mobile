import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

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
  });

  final Widget child;
  final Widget? appBarTitle;
  final List<Widget>? appBarActions;
  final Widget? appBarLeading;
  final bool needAppBar;
  final Widget? bottomNavigationBar;
  final EdgeInsets padding;
  final bool automaticallyImplyAppBarLeading;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: needAppBar
          ? AppBar(
              title: appBarTitle,
              actions: appBarActions,
              leading: appBarLeading,
              automaticallyImplyLeading: automaticallyImplyAppBarLeading,
            )
          : null,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return false;
        },
        child: GestureDetector(
          child: scrollable
              ? SingleChildScrollView(
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
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
