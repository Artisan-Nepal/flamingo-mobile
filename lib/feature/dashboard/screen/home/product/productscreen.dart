import 'package:flamingo/feature/category/data/model/model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final ProductCategory selectedItem;

  ProductScreen({
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextWidget(
          selectedItem.name,
          style: TextStyle(fontSize: 24, color: AppColors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
                'https://plus.unsplash.com/premium_photo-1663838903165-f6a2649f5ae4?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
          ],
        ),
      ),
    );
  }
}
