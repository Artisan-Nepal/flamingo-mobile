import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/dashboard/screen/cart/cartscreen.dart';

import 'package:flamingo/feature/dashboard/screen/home/product/product/productscreen_model.dart';

import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/shared/shared.dart';

import 'package:flamingo/widget/arrowdown/arrowdown.dart';
import 'package:flamingo/widget/cards/bottom_slider.dart';
import 'package:flamingo/widget/cards/contact_card.dart';
import 'package:flamingo/widget/cards/productcard.dart';
import 'package:flamingo/widget/size/sizebar.dart';

import 'package:flamingo/widget/text/text.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  final Product product;

  ProductScreen({
    required this.product,
  });

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isWishlist = false;

  int selectedImageIndex = 0;
  String? chosenSize; // Initialize as null

  final _viewmodel = locator<ProductScreenModel>();

  @override
  void initState() {
    _viewmodel.getlistofproducts();
    widget.product.size.length == 1
        ? chosenSize = widget.product.size[0]
        : chosenSize = null;
    super.initState();

    // Place any initialization logic here if needed
  }

  Widget buildSizeSelector(BuildContext context, Product product) {
    if (product.size.length == 1) {
      // If there is only one size, display "One Size"
      return FieldBar(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.04,
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
        height: MediaQuery.of(context).size.height * 0.04,
        hinttext: 'Select your Size',
        selections: product.size,
        chosenselection: chosenSize,
        onSelectionchange: (size) {
          setState(() {
            print(size);
            chosenSize = size;
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
              product: widget.product,
              chosenSize: _chosensize ?? '',
              title: title,
              height: MediaQuery.of(context).size.height * 0.25,
            )
          ]),
        ));
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
          bottomNavigationBar: FilledButtonWidget(
            label: 'Add to Cart',
            onPressed: () => chosenSize != null
                ? displayPopup(context, widget.product, chosenSize,
                    'Following item has been added to cart.', true)
                : showToast(
                    context,
                    'Please select the size first.',
                    isSuccess: false,
                  ),
          ),
          appBarTitle: TextWidget(
            widget.product.name,
            style: const TextStyle(fontSize: 24, color: AppColors.black),
          ),
          child: SafeArea(child: Consumer<ProductScreenModel>(
            builder: (context, viewmodel, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Swiper
                    Stack(
                      children: [
                        Container(
                          height: 500, // Adjust the height as needed
                          child: Stack(children: [
                            PageView.builder(
                              itemCount: widget.product.imageurl.length,
                              controller: PageController(
                                viewportFraction:
                                    1.0, // Ensure one image is visible at a time
                                initialPage: selectedImageIndex,
                              ),
                              onPageChanged: (index) {
                                setState(() {
                                  selectedImageIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Image.network(
                                  widget.product.imageurl[index],
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ]),
                        ),
                        CreateWishlistIcon(context),
                      ],
                    ),
                    VerticalSpaceWidget(height: 3),
                    // Product Lines
                    Row(
                      children: List.generate(widget.product.imageurl.length,
                          (index) {
                        return Expanded(
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: index == selectedImageIndex
                                  ? AppColors.black
                                  : AppColors.grayLighter,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 2.0), // Adjust the gap
                          ),
                        );
                      }),
                    ),
                    //wishlist button

                    VerticalSpaceWidget(height: 5),
                    // Product Name
                    TextWidget(
                      widget.product.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    VerticalSpaceWidget(height: 5),
                    // Product Brand
                    TextWidget(
                      widget.product.brand,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grayLight, // Modify color as needed
                      ),
                    ),
                    VerticalSpaceWidget(height: 5),
                    // Product Price
                    TextWidget(
                      widget.product.price,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const VerticalSpaceWidget(height: 15),
                    ///////////////////
                    buildSizeSelector(context, widget.product),
                    const VerticalSpaceWidget(height: 5),
                    //////////////////
                    ArrowDown(title: 'The Details', body: FirstColumn()),
                    const VerticalSpaceColoredWidget(
                      height: 35,
                      thickness: 1,
                      color: AppColors.grayLight,
                    ),

                    ArrowDown(title: 'Size And Fit', body: SecondColumn()),
                    const VerticalSpaceColoredWidget(
                      height: 35,
                      thickness: 1,
                      color: AppColors.grayLight,
                    ),
                    ArrowDown(title: 'Composition And Care', body: Column()),
                    const VerticalSpaceColoredWidget(
                      height: 35,
                      thickness: 1,
                      color: AppColors.grayLight,
                    ),
                    ArrowDown(title: 'Delivery And Return', body: Column()),
                    const VerticalSpaceColoredWidget(
                      height: 35,
                      thickness: 1,
                      color: AppColors.grayLight,
                    ),
                    ArrowDown(title: 'About The Brand', body: Column()),
                    const VerticalSpaceColoredWidget(
                      height: 35,
                      thickness: 1,
                      color: AppColors.grayLight,
                    ),
                    ContactCard(),
                    const VerticalSpaceColoredWidget(
                      height: 35,
                      thickness: 1,
                      color: AppColors.grayLight,
                    ),
                    // ProductCatalog(products: _viewmodel.getlistofproducts(), title: 'Recommendations', height: 250),
                  ],
                ),
              );
            },
          ))),
    );
  }

  Widget FirstColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ... (previous widgets)

        // Product Highlights
        const VerticalSpaceWidget(height: 10),
        const TextWidget(
          'Product Highlights',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.grayLight,
          ),
        ),
        const VerticalSpaceWidget(height: 5),
        TextWidget(
          widget.product.description,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        // BrandID
        const VerticalSpaceWidget(height: 20),
        TextWidget(
          'BrandID',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.grayLight,
          ),
        ),
        const VerticalSpaceWidget(height: 5),
        TextWidget(
          widget.product.id,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget SecondColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ... (previous widgets)

        // Product Highlights
        const VerticalSpaceWidget(height: 10),
        const TextWidget(
          'Product Size Available',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.grayLight,
          ),
        ),
        const VerticalSpaceWidget(height: 5),
        Row(
          children: List.generate(
            widget.product.size.length,
            (index) => Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.grayLighter,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextWidget(
                widget.product.size[index],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      ],
    );

    //
  }

  Widget CreateWishlistIcon(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: IconButton(
        icon: Icon(
          Icons.favorite,
          color: isWishlist ? AppColors.pink : AppColors.grayLighter,
        ),
        onPressed: () {
          // Toggle the wishlist status
          setState(() {
            isWishlist = !isWishlist;
          });

          // Handle your wishlist logic here
          if (isWishlist) {
            displayPopup(context, widget.product, chosenSize,
                'Following Product Added to Wishlist.', false);
            print('Added to wishlist');
          } else {
            displayPopup(context, widget.product, chosenSize,
                'Following Product Removed from Wishlist.', false);
            print('Removed from wishlist');
          }
        },
      ),
    );
  }
}
