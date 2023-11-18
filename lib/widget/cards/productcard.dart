import 'package:flamingo/feature/dashboard/screen/cart/cartscreen.dart';
import 'package:flamingo/feature/dashboard/screen/home/wishlist/wishlist_screen.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/shared/util/colors.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String chosenSize;
  final String title;
  final double height;
  final bool cartorwishlist;

  ProductCard({
    required this.product,
    required this.chosenSize,
    required this.title,
    required this.height,
    required this.cartorwishlist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          VerticalSpaceColoredWidget(
            height: 10,
            thickness: 1,
            color: AppColors.grayLight,
          ),
          VerticalSpaceWidget(height: 5),
          // Product Image
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product.imageurl[0]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              HorizontalSpaceWidget(width: 25),
              // Product Details
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      "${product.name}",
                      style: TextStyle(
                          fontSize: 20,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextWidget(
                      "${product.brand}",
                      style: TextStyle(fontSize: 16, color: AppColors.grayDark),
                    ),
                    TextWidget(
                      chosenSize != '' ? "Size: ${chosenSize}" : '',
                      style: TextStyle(fontSize: 16, color: AppColors.grayDark),
                    ),
                    TextWidget(
                      "${product.price}",
                      style: TextStyle(
                          fontSize: 20,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          VerticalSpaceWidget(height: 30),
          cartorwishlist == true
              ? ButtonWidget(
                  fontSize: 20,
                  label: 'View Cart',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Cartscreen(),
                      ),
                    );
                  })
              : ButtonWidget(
                  label: 'View WishList',
                  fontSize: 20,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WishlistScreen(),
                      ),
                    );
                  })
        ],
      ),
    );
  }
}
