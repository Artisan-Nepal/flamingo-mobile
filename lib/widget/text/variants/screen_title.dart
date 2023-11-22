import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle(this.title, {super.key});

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
