import 'package:flamingo/feature/dashboard/dashboard.dart';
import 'package:flamingo/feature/dashboard/screen/home/product/product_list_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  final String category;
  final List<String> items = [
    "25% off",
    "Gifts",
    "New in",
    "Clothing",
    "Shoes",
    "Jewellery",
    "Accessories",
    "Trainers",
    "Bags",
    "Watches",
    "Underwear",
    "Socks",
    "Preowned",
    "Activewear",
  ];

  ItemList(this.category);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey, // Add a slight grey border between items
          height: 1, // Set the height of the divider
        );
      },
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 4, vertical: 2), // Adjust padding
          title: TextWidget(
            items[index],
            textAlign: TextAlign.left,
            style: TextStyle(color: AppColors.black),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_outlined,
            color: AppColors.black,
          ), // Arrow icon
          onTap: () {
            print(category); //try
            // When an item is tapped, navigate to ProductScreen and pass the selected item as an argument
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
        );
      },
    );
  }
}
