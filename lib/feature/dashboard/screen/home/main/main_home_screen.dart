import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/dashboard/screen/home/main/main_home_screen_model.dart';
import 'package:flamingo/feature/product/data/model/product_color.dart';
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
        appBarTitle: const TextWidget(
          'Home',
          style: TextStyle(fontSize: 20),
        ),
        bottomNavigationBar: const VerticalSpaceWidget(height: 2),
        child: SafeArea(
          child: Consumer<MainHometScreenModel>(
            builder: (context, viewModel, child) {
              return buildProductCatalogFutureBuilder();
            },
          ),
        ),
      ),
    );
  }

  Widget buildProductCatalogFutureBuilder() {
    return FutureBuilder<List<Product>>(
      future: _viewmodel.getlistofproducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator.adaptive();
        } else if (snapshot.hasError) {
          return TextWidget('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return TextWidget('No products available.');
        } else {
          return Column(
            children: [
              ProductCatalog(
                products: snapshot.data,
                title: 'New In',
                height: 250,
              ),
            ],
          );
        }
      },
    );
  }
}
