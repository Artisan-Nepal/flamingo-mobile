import 'package:flamingo/feature/dashboard/screen/home/product/product/productscreen.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/shared/util/util.dart';
import 'package:flamingo/widget/cards/bottom_slider.dart';
import 'package:flamingo/widget/cards/productcard.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

class ProductCatalog extends StatefulWidget {
  final List<Product> products;
  final String title;
  final double height;
  final double width;
  final List<Product> wishlist;
  // final List<bool>? wishlist;

  const ProductCatalog({
    // required this.wishlist,
    required this.products,
    required this.wishlist,
    required this.title,
    required this.width,
    required this.height,
  });

  @override
  _ProductCatalogState createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        widget.products.isNotEmpty
            ? SizedBox(
                height: widget.height,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: widget.products.map((product) {
                    int index = widget.products.indexOf(product);
                    return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Card(
                        color: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ProductScreen(product: product),
                            ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Stack(children: [
                                  Image.network(
                                    product.imageurl[0],
                                    width: widget.width,
                                    height: widget.height - 100,
                                    fit: BoxFit.fill,
                                  ),
                                  CreateWishlistIcon(context, index, product)
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      product.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      product.price,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList()),
                ),
              )
            : const Center(child: TextWidget('No products to display.'))
      ],
    );
  }

  Widget CreateWishlistIcon(BuildContext context, int index, Product _product) {
    return Positioned(
      top: 0,
      right: 0,
      child: IconButton(
        icon: Icon(
          widget.wishlist.any((element) => element.id == _product.id)
              ? Icons.favorite
              : Icons.favorite_border,
          color: widget.wishlist.any((element) => element.id == _product.id)
              ? AppColors.pink
              : AppColors.black,
        ),
        onPressed: () {
          print('asdadsadad');
          // Toggle the wishlist status
          setState(() {
            // Check if the product is in the wishlist based on productId
            if (widget.wishlist.any((element) => element.id == _product.id)) {
              // If the product is in the wishlist, remove it
              widget.wishlist
                  .removeWhere((element) => element.id == _product.id);
            } else {
              // If the product is not in the wishlist, add it
              widget.wishlist.add(_product);
            }
          });

          // Handle your wishlist logic here
          if (widget.wishlist.any((element) => element.id == _product.id)) {
            displayPopup(context, _product,
                'Following Product Added to Wishlist.', false);
            print('Added to wishlist');
          } else {
            displayPopup(context, _product,
                'Following Product Removed from Wishlist.', false);
            print('Removed from wishlist');
          }
        },
      ),
    );
  }

  displayPopup(context, Product product, String title, bool cartorwishlist) {
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
              chosenSize: '',
              title: title,
              height: 150,
            )
          ]),
        ));
  }
}
