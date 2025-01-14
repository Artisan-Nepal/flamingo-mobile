import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitledScreen extends StatelessWidget {
  const TitledScreen({
    super.key,
    required this.child,
    required this.title,
    this.scrollable = true,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Dimens.spacingSizeDefault,
      vertical: Dimens.spacingSizeDefault,
    ),
    this.appbarActions,
    this.automaticallyImplyAppBarLeading = true,
    this.scrollController,
    this.sliverChildren,
  });

  final String title;
  final Widget child;
  final bool scrollable;
  final EdgeInsets padding;
  final List<Widget>? appbarActions;
  final bool automaticallyImplyAppBarLeading;
  final ScrollController? scrollController;
  final List<Widget>? sliverChildren;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacingSizeSmall),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBackButton(context),
                  if (appbarActions != null)
                    Row(
                      children: appbarActions!,
                    )
                ],
              ),
            ),
            const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
            Padding(
              padding: const EdgeInsets.only(left: Dimens.spacingSizeDefault),
              child: ScreenTitleWidget(
                title,
              ),
            ),
            Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    if (!NavigationHelper.canPop(context) || !automaticallyImplyAppBarLeading) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        NavigationHelper.pop(context);
      },
      child: Container(
        color: AppColors.transparent,
        padding: EdgeInsets.only(
          top: Dimens.spacing_2,
          right: Dimens.spacingSizeExtraSmall,
        ),
        child: const Icon(CupertinoIcons.back),
      ),
    );
  }
}
