import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flutter/material.dart';

void bottomSlider(BuildContext context, Widget widget) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return widget;
    },
  );
}
