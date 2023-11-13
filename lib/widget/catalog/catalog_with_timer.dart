import 'dart:async';

import 'package:flamingo/feature/dashboard/screen/home/product/product/productscreen.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flutter/material.dart';

class ProductCatalog extends StatefulWidget {
  final List<Product>? products;
  final String title;
  final double height;

  ProductCatalog({
    required this.products,
    required this.title,
    required this.height,
  });

  @override
  _ProductCatalogState createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog>
    with WidgetsBindingObserver {
  final scrollController = ScrollController();
  Timer? timer;
  final int scrollDuration = 3; // Adjust scrolling duration as needed

  @override
  void initState() {
    super.initState();
    startScrolling();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    stopScrolling();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startScrolling();
    } else {
      stopScrolling();
    }
  }

  void startScrolling() {
    // Calculate the total width based on the number of products
    double totalWidth =
        (widget.products?.length ?? 0) * 170.0; // Adjust the width as needed

    timer = Timer.periodic(Duration(seconds: scrollDuration), (timer) {
      if (scrollController.hasClients) {
        if (scrollController.offset +
                scrollController.position.viewportDimension >=
            totalWidth) {
          scrollController.animateTo(
            0,
            duration: Duration(seconds: scrollDuration),
            curve: Curves.linear,
          );
        } else {
          scrollController.animateTo(
            scrollController.offset +
                scrollController.position.viewportDimension,
            duration: Duration(seconds: scrollDuration),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  void stopScrolling() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // Widget contents remain the same as before
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
        SizedBox(
          height: widget.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            child: Row(
              children: widget.products?.map((product) {
                    return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              // Navigate to ProductsScreen and pass the tapped product
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ProductScreen(product: product),
                              ));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  product.imageurl[0],
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.fill,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    product.brand,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    product
                                        .price, // Replace with the actual price
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  }).toList() ??
                  [],
            ),
          ),
        ),
      ],
    );
  }
}
