import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/dashboard/screen/cart/cartscreen.dart';
import 'package:flamingo/feature/dashboard/screen/home/main/main_home_screen_model.dart';
import 'package:flamingo/shared/shared.dart';

import 'package:flamingo/widget/catalog/catalog.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key});

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final _viewmodel = locator<MainHometScreenModel>();
  // List<bool> wishlist = [];
  @override
  void initState() {
    super.initState();
    _viewmodel.getid();
    _viewmodel.getuserprofile();

    _viewmodel.getlistofproducts();
    _viewmodel.getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewmodel,
      builder: (context, child) => DefaultScreen(
        appBarActions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Cartscreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
              ),
            ),
          ),
        ],
        appBarTitle: const TextWidget(
          'Home',
          style: TextStyle(fontSize: 20),
        ),
        bottomNavigationBar: const VerticalSpaceWidget(height: 2),
        child: SafeArea(
          child: Consumer<MainHometScreenModel>(
            builder: (context, viewModel, child) {
              // for (int i = 0; i < viewModel.listofproducts.data!.length; i++) {
              //   wishlist.add(false);
              // }
              if (viewModel.listofproducts.isLoading ||
                  viewModel.wishlist.isLoading) {
                return const CircularProgressIndicator();
              }
              return Column(
                children: [
                  ProductCatalog(
                    wishlist: viewModel.wishlist.data!,
                    width: MediaQuery.of(context).size.width * 0.65,
                    // wishlist: wishlist,
                    products: viewModel.listofproducts.data!,
                    title: 'New In',
                    height: MediaQuery.of(context).size.height * 0.67,
                  ),
                  const VerticalSpaceWidget(height: Dimens.iconSizeSmall),
                  ButtonWidget(
                    borderColor: AppColors.black,
                    needBorder: true,
                    backgroundColor: AppColors.white,
                    textColor: AppColors.black,
                    label: 'Shop Now',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    borderwidth: 1.5,
                    onPressed: () {
                      print('shop now');
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
