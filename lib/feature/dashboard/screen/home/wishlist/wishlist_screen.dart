import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/dashboard/screen/cart/cartscreen.dart';

import 'package:flamingo/feature/dashboard/screen/home/product/product/productscreen.dart';

import 'package:flamingo/feature/dashboard/screen/home/wishlist/wishlistscreenmodel.dart';
import 'package:flamingo/feature/product/data/model/product.dart';

import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/cards/bottom_slider.dart';
import 'package:flamingo/widget/cards/productcard.dart';
import 'package:flamingo/widget/cards/productcatalogcard.dart';

import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flamingo/widget/size/sizebar.dart';
import 'package:flamingo/widget/space/space.dart';

import 'package:flamingo/widget/text/text.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => ProfileEditScreenState();
}

class ProfileEditScreenState extends State<WishlistScreen> {
  final _viewmodel = locator<WishlistScreenModel>();
  List<String?> chosenSize = [];

  @override
  void initState() {
    _viewmodel.getid();
    _viewmodel.getuserprofile();
    _viewmodel.getWishlist();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
        appBarTitle: TextWidget(
          'WishList',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        //  _viewmodel.profile.isLoading
        //     ? const CircularProgressIndicator()
        //     : TextWidget(
        //         _viewmodel.profile.data!.wishlist.isEmpty
        //             ? 'Wishlist'
        //             : 'Wishlist (${_viewmodel.profile.data!.wishlist.length})',
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           fontSize: 24,
        //         ),
        //       ),
        bottomNavigationBar: const VerticalSpaceWidget(height: 0),
        child: Consumer<WishlistScreenModel>(
          builder: (context, viewModel, child) {
            if (viewModel.listofproducts.isLoading) {
              const CircularProgressIndicator();
            }
            if (viewModel.listofproducts.data != null) {
              return viewModel.listofproducts.data!.isNotEmpty
                  ? GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          childAspectRatio: 0.38),
                      itemCount: viewModel.listofproducts.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Handle the brand box tap, maybe navigate to a brand detail screen
                          },
                          child: createProductCard(
                              crossbutton: true,
                              close: () {
                                setState(() {
                                  viewModel.removefromlist(index);
                                  chosenSize.removeAt(index);
                                });
                              },
                              height: MediaQuery.of(context).size.height * 0.67,
                              width: MediaQuery.of(context).size.width * 0.65,
                              onimgtap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                        product: viewModel
                                            .listofproducts.data![index]),
                                  ),
                                );
                              },
                              topText:
                                  viewModel.listofproducts.data![index].name,
                              bottomText:
                                  viewModel.listofproducts.data![index].price,
                              imageUrl: viewModel
                                  .listofproducts.data![index].imageurl[0],
                              specialText: viewModel
                                  .listofproducts.data![index].discount,
                              specialColor: AppColors.orange,
                              widget: createaddtocartbutton(
                                  context,
                                  viewModel.listofproducts.data![index],
                                  index)),
                        );
                      },
                    )
                  : Center(
                      child: const TextWidget('No item in your wishlist.'),
                    );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  createaddtocartbutton(BuildContext context, Product product, int index) {
    if (_viewmodel.products[index].size.length == 1) {
      chosenSize.add(_viewmodel.products[index].size[0]);
    } else {
      chosenSize.add(null);
    }
    return Column(
      children: [
        buildSizeSelector(context, product, index),
        VerticalSpaceWidget(height: Dimens.iconSizeExtraSmall),
        ButtonWidget(
          borderwidth: 1.5,
          textColor: AppColors.black,
          backgroundColor: AppColors.white,
          needBorder: true,
          borderColor: AppColors.black,
          width: 158,
          label: 'Add to Cart',
          onPressed: () {
            if (chosenSize[index] != null) {
              displayPopup(context, product, chosenSize[index],
                  'Following Item has been added to cart.', true);
            } else {
              showToast(context, 'Please select size.');
            }
          },
        ),
      ],
    );
  }

  Widget buildSizeSelector(BuildContext context, Product product, int index) {
    if (product.size.length == 1) {
      // If there is only one size, display "One Size"
      return FieldBar(
        width: MediaQuery.of(context).size.width,
        height: 36,
        labelText: '1 Size',
        selected: '1 Size',
        onchange: (size) {
          // Do nothing when the size changes (since it's fixed)
        },
      );
    } else {
      // If there are multiple sizes, allow the user to choose a size
      return DropSelector(
        width: MediaQuery.of(context).size.width,
        hinttext: 'Size',
        height: 36,
        selections: product.size,
        chosenselection: chosenSize[index],
        onSelectionchange: (size) {
          setState(() {
            print(size);
            chosenSize[index] = size;
            print(chosenSize[index]);
          });
        },
      );
    }
  }

  displayPopup(context, Product product, String? _chosensize, String title,
      bool cartorwishlist) {
    final double screenHeight = MediaQuery.of(context).size.height;

    bottomSlider(
        context,
        Container(
          height: screenHeight * 0.5,
          padding: EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            // Product
            ProductCard(
              cartorwishlist: cartorwishlist,
              product: product,
              chosenSize: _chosensize ?? '',
              title: title,
              height: 150,
            )
          ]),
        ));
  }
}
