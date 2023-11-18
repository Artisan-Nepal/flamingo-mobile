import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/dashboard/screen/cart/cartscreen.dart';
import 'package:flamingo/feature/dashboard/screen/home/brand/BrandProfileScreen.dart';
import 'package:flamingo/feature/dashboard/screen/home/brand/brand_screen_model.dart';

import 'package:flamingo/shared/util/colors.dart';
import 'package:flamingo/widget/cards/brandcard.dart';

import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen({super.key});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  final _viewmodel = locator<BrandScreenModel>();

  @override
  void initState() {
    _viewmodel.getbranddata();
    super.initState();

    // Place any initialization logic here if needed
  }

  @override
  void dispose() {
    super.dispose();
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
          'Brands',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        bottomNavigationBar: const VerticalSpaceWidget(height: 0),
        child: SafeArea(
          child: Consumer<BrandScreenModel>(
            builder: (context, viewModel, child) {
              if (viewModel.listofprofile.isLoading) {
                return const CircularProgressIndicator();
              }
              return GridView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.6,
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemCount: viewModel.listofprofile.data!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle the brand box tap, maybe navigate to a brand detail screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BrandProfileScreen(
                            user: viewModel.listofprofile.data![index],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: createBrandCard(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.5,
                          topText: viewModel.listofprofile.data![index].name,
                          bottomText: 'Listing',
                          imageUrl: viewModel
                              .listofprofile.data![index].profilePicture,
                          // specialText: '25% off',
                          specialColor: AppColors.orange),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
