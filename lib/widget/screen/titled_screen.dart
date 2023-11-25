import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/cupertino.dart';

class TitledScreen extends StatelessWidget {
  const TitledScreen({
    super.key,
    required this.child,
    required this.title,
    this.scrollable = true,
    this.padding = const EdgeInsets.all(Dimens.spacingSizeDefault),
  });

  final String title;
  final Widget child;
  final bool scrollable;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      needAppBar: false,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
            _buildBackButton(context),
            const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
            ScreenTitleWidget(
              title,
            ),
            NotificationListener<OverscrollIndicatorNotification>(
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
