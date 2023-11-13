import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/dashboard/screen/cart/cartscreenmodel.dart';
import 'package:flamingo/feature/dashboard/screen/home/product/product/productscreen.dart';

import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/cards/bottom_slider.dart';

import 'package:flamingo/widget/cards/productcatalogcard.dart';

import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flamingo/widget/size/sizebar.dart';
import 'package:flamingo/widget/space/space.dart';

import 'package:flamingo/widget/text/text.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cartscreen extends StatefulWidget {
  const Cartscreen({super.key});

  @override
  State<Cartscreen> createState() => ProfileEditScreenState();
}

class ProfileEditScreenState extends State<Cartscreen> {
  final _viewmodel = locator<CartScreenmodel>();
  List<String?> chosenSize = [];
  List<String?> quantity = [];
  String _total = '';

  @override
  void initState() {
    _viewmodel.getid();
    _viewmodel.getuserprofile();
    _viewmodel.getcartlist();
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
        appBarTitle: TextWidget(
          'Cart',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        bottomNavigationBar: ButtonWidget(
            label: 'Cash Out',
            onPressed: () {
              //cashout logic

              if (quantity.contains(null) || chosenSize.contains(null)) {
                displayPopup(
                    context,
                    true,
                    'Please choose the sizes and quantities of items before checking out.',
                    'Pick all quantities and sizes');
              } else {
                displayPopup(context, false, 'Total: ${_total}',
                    'Cashing out. Yout items are:');
              }
            }),
        child: Consumer<CartScreenmodel>(
          builder: (context, viewModel, child) {
            if (viewModel.listofproducts.isLoading ||
                viewModel.profile.isLoading ||
                viewModel.id.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            double subtotal = 0;

            for (int i = 0; i < viewModel.listofproducts.data!.length; i++) {
              subtotal = subtotal +
                  double.parse(viewModel.listofproducts.data![i].price) *
                      (quantity.length > i && quantity[i] != null
                          ? double.parse(quantity[i]!)
                          : 0);
            }
            double total = subtotal + 50;
            _total = total.toString();

            return Column(
              children: [
                Column(
                  children: [
                    TextWidget(
                      'Subtotal: ${subtotal.toStringAsFixed(3)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.black),
                    ),
                    TextWidget('Shipping: \$50'),
                    TextWidget('Total: ${total.toStringAsFixed(3)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black)),
                    VerticalSpaceColoredWidget(
                      height: 5,
                      thickness: 1,
                      color: AppColors.grayDarker,
                    )
                  ],
                ),
                viewModel.listofproducts.data!.isNotEmpty
                    ? ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: viewModel.listofproducts.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onLongPress: () {
                                if (viewModel
                                    .selectedorunselected.data![index]) {
                                  viewModel.itemremoval(index);
                                } else {
                                  viewModel.itemselection(index);
                                }
                              },
                              child: Stack(children: [
                                createProductCard(
                                    vertical: false,
                                    border: viewModel
                                        .selectedorunselected.data![index],
                                    crossbutton: true,
                                    onimgtap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ProductScreen(
                                              product: viewModel
                                                  .listofproducts.data![index]),
                                        ),
                                      );
                                    },
                                    close: () {
                                      setState(() {
                                        viewModel.removefromlist(index);
                                        chosenSize.removeAt(index);
                                        quantity.removeAt(index);
                                        //aile chaldaina
                                      });
                                    },
                                    height: 200,
                                    width: MediaQuery.of(context).size.width /
                                        2.95,
                                    topText: viewModel
                                        .listofproducts.data![index].name,
                                    bottomText: viewModel
                                        .listofproducts.data![index].price,
                                    imageUrl: viewModel.listofproducts
                                        .data![index].imageurl[0],
                                    specialText: viewModel
                                        .listofproducts.data![index].discount,
                                    specialColor: AppColors.orange,
                                    widget: createbutton(
                                        context,
                                        viewModel.listofproducts.data![index],
                                        index)),
                                chosenSize[index] != null &&
                                        quantity[index] != null
                                    ? Positioned(
                                        bottom: 4,
                                        right: 10,
                                        child: TextWidget(
                                            (double.parse(quantity[index]!) *
                                                    double.parse(viewModel
                                                        .listofproducts
                                                        .data![index]
                                                        .price))
                                                .toStringAsFixed(3)))
                                    : VerticalSpaceWidget(height: 0)
                              ]));
                        },
                      )
                    : Center(child: const TextWidget('No item in your cart.')),
              ],
            );
          },
        ),
      ),
    );
  }

  createbutton(BuildContext context, Product product, int index) {
    if (chosenSize.length <= index) {
      if (_viewmodel.products[index].size.length == 1) {
        chosenSize.add(_viewmodel.products[index].size[0]);
      } else {
        chosenSize.add(null);
      }
    } else {}

    if (quantity.length <= index) {
      quantity.add(null);
    }
    return Column(
      children: [
        Row(
          children: [
            buildSizeSelector(context, product, index),
            HorizontalSpaceWidget(width: Dimens.spacingSizeExtraSmall),
            buildQuantitySelector(context, product, index),
          ],
        ),
      ],
    );
  }

  Widget buildSizeSelector(BuildContext context, Product product, int index) {
    if (product.size.length == 1) {
      // If there is only one size, display "One Size"
      return FieldBar(
        width: 80,
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
        hinttext: 'Size',
        height: 36,
        width: 80,
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

  Widget buildQuantitySelector(
      BuildContext context, Product product, int index) {
    // If there are multiple sizes, allow the user to choose a size
    return DropSelector(
      hinttext: 'Qty',
      height: 36,
      width: 80,
      selections: ['none', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      chosenselection: quantity[index],
      onSelectionchange: (_quantity) {
        setState(() {
          print(_quantity);
          if (_quantity != 'none') {
            quantity[index] = _quantity;
          } else {
            quantity[index] = null;
          }
          print(quantity[index]);
        });
      },
    );
  }

  displayPopup(
    context,
    bool error,
    String total,
    String title,
  ) {
    final double screenHeight = MediaQuery.of(context).size.height;
    Widget val = SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        Column(
          children: [
            Center(
                child: TextWidget(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.black),
            )),
            error
                ? TextWidget(
                    ' ${total}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  )
                : Container(
                    height: 300,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _viewmodel.products.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                child: createProductCard(
                                  vertical: false,
                                  height: 200,
                                  width: 130,
                                  widget: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(children: [
                                      TextWidget('Price: ' +
                                          (double.parse(_viewmodel
                                                      .products[index].price) *
                                                  double.parse(
                                                      quantity[index]!))
                                              .toStringAsFixed(3)),
                                      VerticalSpaceWidget(height: 5),
                                      TextWidget(
                                          ' Quantity: ${quantity[index]}')
                                    ]),
                                  ),
                                  topText: _viewmodel.products[index].name,
                                  bottomText: '',
                                  imageUrl:
                                      _viewmodel.products[index].imageurl[0],
                                ),
                              );
                            },
                          ),
                          VerticalSpaceColoredWidget(
                            height: 4,
                            thickness: 2,
                            color: AppColors.grayLight,
                          ),
                          TextWidget(
                            '${total}',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          ButtonWidget(
                            label: 'Check Out',
                            onPressed: () {
                              print('checked out');
                            },
                          )
                        ],
                      ),
                    ),
                  ),
          ],
        )
      ]),
    );
    bottomSlider(
      context,
      val,
    );
  }
}
