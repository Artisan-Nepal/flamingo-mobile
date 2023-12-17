import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/loader/circular_progress_indicator_widget.dart';
import 'package:flutter/material.dart';

class DefaultScreenLoaderWidget extends StatelessWidget {
  const DefaultScreenLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: Dimens.spacing_64),
      child: Center(
        child: CircularProgressIndicatorWidget(
          size: Dimens.iconSizeLarge,
        ),
      ),
    );
  }
}
