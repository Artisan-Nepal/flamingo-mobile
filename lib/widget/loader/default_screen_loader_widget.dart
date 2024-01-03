import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/loader/circular_progress_indicator_widget.dart';
import 'package:flutter/material.dart';

class DefaultScreenLoaderWidget extends StatelessWidget {
  const DefaultScreenLoaderWidget({
    super.key,
    this.manuallyCenter = false,
    this.manualTop,
  });

  final bool manuallyCenter;
  final double? manualTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: Dimens.spacing_64,
          top: manuallyCenter
              ? SizeConfig.screenHeight * (manualTop ?? 0.3)
              : 0),
      child: const Center(
        child: CircularProgressIndicatorWidget(
          size: Dimens.iconSizeLarge,
        ),
      ),
    );
  }
}
