import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key, required this.child, this.appBarTitle});

  final Widget child;
  final Widget? appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.spacingSizeDefault),
          child: child,
        ),
      ),
    );
  }
}
