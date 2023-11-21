import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flutter/cupertino.dart';

class WishlistListingScreen extends StatelessWidget {
  const WishlistListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultScreen(
      appBarTitle: Text("Wishlist"),
      child: SizedBox(),
    );
  }
}
