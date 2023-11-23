import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      scrollable: false,
      padding: EdgeInsets.zero,
      appBarTitle: Text('Product Details'),
      child: SizedBox(),
    );
  }
}
