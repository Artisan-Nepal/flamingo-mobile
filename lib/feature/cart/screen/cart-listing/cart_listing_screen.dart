import 'package:flamingo/widget/screen/screen.dart';
import 'package:flutter/cupertino.dart';

class CartListingScreen extends StatefulWidget {
  const CartListingScreen({super.key});

  @override
  State<CartListingScreen> createState() => _CartListingScreenState();
}

class _CartListingScreenState extends State<CartListingScreen> {
  @override
  Widget build(BuildContext context) {
    return const TitledScreen(
      title: 'SHOPPING BAG (2)',
      child: Column(),
    );
  }
}
