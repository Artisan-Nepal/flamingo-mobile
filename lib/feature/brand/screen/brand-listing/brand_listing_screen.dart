import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flutter/cupertino.dart';

class BrandListingScreen extends StatelessWidget {
  const BrandListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultScreen(
      appBarTitle: Text('Brands'),
      child: SizedBox(),
    );
  }
}
