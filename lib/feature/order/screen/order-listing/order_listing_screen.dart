import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class OrderListingScreen extends StatefulWidget {
  const OrderListingScreen({super.key});

  @override
  State<OrderListingScreen> createState() => _OrderListingScreenState();
}

class _OrderListingScreenState extends State<OrderListingScreen> {
  @override
  Widget build(BuildContext context) {
    return TitledScreen(
      title: 'Orders (2)',
      child: Container(),
    );
  }
}
