import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/seller/screen/manage-seller-profile/manage_seller_profile_screen.dart';
import 'package:flamingo/feature/seller/screen/seller-profile/seller_profile_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/list-tile/list_tile.dart';
import 'package:flamingo/widget/screen/titled_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySellerProfileScreen extends StatefulWidget {
  const MySellerProfileScreen({super.key});

  @override
  State<MySellerProfileScreen> createState() => _MySellerProfileScreenState();
}

class _MySellerProfileScreenState extends State<MySellerProfileScreen> {
  final _viewModel = locator<SellerDetailViewModel>();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child:
          Consumer<SellerDetailViewModel>(builder: (context, viewModel, child) {
        return TitledScreen(
          title: authViewModel.user!.seller.storeName,
          child: Column(
            children: [
              ListTileV2Wdiget(
                title: 'Manage store',
                onPressed: () {
                  NavigationHelper.push(
                    context,
                    ManageSellerScreen(
                      existingSeller: authViewModel.user?.seller,
                    ),
                  );
                },
              ),
              ListTileV2Wdiget(
                title: 'Add Product',
                onPressed: () {},
              ),
              ListTileV2Wdiget(
                title: 'Products',
                onPressed: () {},
              ),
              ListTileV2Wdiget(
                title: 'Statements',
                onPressed: () {},
              ),
            ],
          ),
        );
      }),
    );
  }
}
