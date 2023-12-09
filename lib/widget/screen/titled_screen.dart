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
  });

  final String title;
  final Widget child;
  final bool scrollable;
  final EdgeInsets padding;
  final List<Widget>? appbarActions;

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
    if (!NavigationHelper.canPop(context)) return const SizedBox();

    return GestureDetector(
      onTap: () {
        NavigationHelper.pop(context);
      },
      child: const Icon(CupertinoIcons.back),
    );
  }
}
