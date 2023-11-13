import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/dashboard/screen/cart/cartscreen.dart';
import 'package:flamingo/feature/dashboard/screen/home/main/main_home_screen_model.dart';
import 'package:flamingo/feature/dashboard/screen/home/wishlist/wishlist_screen.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
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
  @override
  void initState() {
    super.initState();
    _viewmodel.getlistofproducts();
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
                    builder: (context) => Cartscreen(),
                  ),
                );
              },
              icon: Icon(
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
              if (viewModel.listofproducts.isLoading) {
                return const CircularProgressIndicator();
              }
              return Column(
                children: [
                  ProductCatalog(
                    width: 150,
                    products: viewModel.listofproducts.data,
                    title: 'New In',
                    height: 250,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
