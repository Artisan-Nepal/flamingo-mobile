import 'package:flamingo/feature/dashboard/screen/home/search/searchresult_screen.dart';
import 'package:flamingo/shared/util/util.dart';
import 'package:flutter/material.dart';

class Search_Bar extends StatefulWidget {
  final String category;
  final Function?
      onSearchPressed; // Custom onPressed function for search button

  Search_Bar({this.onSearchPressed, required this.category});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<Search_Bar> {
  bool showSearchButton = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {
        showSearchButton = _searchController.text.isNotEmpty;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _Searchbutton() {
    if (widget.onSearchPressed != null) {
      // Call the onSearchPressed function with the current search query
      widget.onSearchPressed!(_searchController.text);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(
              searchQuery: _searchController.text, category: widget.category),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grayLight, // Background color
        borderRadius:
            BorderRadius.circular(25.0), // Adjust the radius as needed
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          border: InputBorder
              .none, // Remove protruding lines out of the circular border
          prefixIcon: Icon(Icons.search),
          hintText: showSearchButton ? "" : "Search for ${widget.category}",
          suffixIcon: showSearchButton
              ? IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _Searchbutton,
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    //..
                  },
                ),
        ),
      ),
    );
  }
}
