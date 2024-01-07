import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_screen.dart';
import 'package:flamingo/feature/vendor/vendor_listing_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/screen/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class BrandListingScreen extends StatefulWidget {
  const BrandListingScreen({super.key});

  @override
  State<BrandListingScreen> createState() => _BrandListingScreenState();
}

class _BrandListingScreenState extends State<BrandListingScreen> {
  final _viewModel = locator<VendorListingViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.getVendors();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: TitledScreen(
        automaticallyImplyAppBarLeading: false,
        title: 'Brands',
        scrollable: false,
        appbarActions: const [CartButtonWidget()],
        child: Consumer<VendorListingViewModel>(
          builder: (context, viewModel, child) {
            if (!viewModel.vendorUseCase.hasCompleted) {
              return const DefaultScreenLoaderWidget();
            }
            final vendors = viewModel.vendorUseCase.data?.rows ?? [];
            return ListView.builder(
              itemCount: vendors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    NavigationHelper.push(
                      context,
                      ProductListingScreen(
                        title: vendors[index].storeName,
                        productListingType: ProductListingType.vendor,
                        vendor: vendors[index],
                      ),
                    );
                  },
                  child: Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.spacingSizeDefault,
                    ),
                    margin: const EdgeInsets.only(
                        bottom: Dimens.spacingSizeDefault),
                    color: AppColors.grayLighter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vendors[index].storeName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       if (isFavorite) {
                        //         favorites.remove(vendors[index].storeName);
                        //       } else {
                        //         favorites.add(vendors[index].storeName);
                        //       }
                        //     });
                        //   },
                        //   icon: Icon(
                        //     isFavorite ? Icons.favorite : Icons.favorite_border,
                        //     color: isFavorite ? Colors.red : null,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  // child: Center(
                  //   child: Text(vendors[index].storeName,
                  //       textAlign: TextAlign.center,
                  //       style: textTheme(context).bodyMedium!.copyWith(
                  //             fontWeight: FontWeight.bold,
                  //           )),
                  // ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
