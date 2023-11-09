import 'package:flamingo/feature/product/data/model/product_color.dart';
import 'package:flamingo/shared/util/colors.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String chosenSize;
  final String title;
  final double height;

  ProductCard({
    required this.product,
    required this.chosenSize,
    required this.title,
    required this.height,
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
                width: 100,
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product.imageurl[0]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              HorizontalSpaceWidget(width: 10),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      "Product Name: ${product.name}",
                      style: TextStyle(
                          fontSize: 20,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    TextWidget(
                      "Brand: ${product.brand}",
                      style: TextStyle(fontSize: 16, color: AppColors.grayDark),
                    ),
                    TextWidget(
                      "Size: ${chosenSize}",
                      style: TextStyle(fontSize: 16, color: AppColors.grayDark),
                    ),
                    TextWidget(
                      "Price: ${product.price}",
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
          VerticalSpaceWidget(height: 2),
          ButtonWidget(label: 'View Cart', onPressed: () {})
        ],
      ),
    );
  }
}
