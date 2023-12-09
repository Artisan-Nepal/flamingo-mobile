import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/screen/screen.dart';
import 'package:flutter/cupertino.dart';

class BrandListingScreen extends StatelessWidget {
  const BrandListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TitledScreen(
      title: 'Brands',
      appbarActions: const [CartButtonWidget()],
      child: Column(children: []),
    );
  }
}
