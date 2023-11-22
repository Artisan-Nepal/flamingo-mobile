import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class ScreenTitleWidget extends StatelessWidget {
  const ScreenTitleWidget(this.title, {super.key});

  final String title;
  @override
  Widget build(BuildContext context) {
    return TextWidget(
      title.toUpperCase(),
      style: textTheme(context).titleLarge!.copyWith(
            fontWeight: FontWeight.w900,
          ),
    );
  }
}
